#!/usr/bin/env bash
# Prepare a lean-eval checkout (or a project that reuses its dependencies) to download TauCeti's
# build outputs instead of compiling TauCeti.
#
# Usage: bash scripts/fetch_dependency_caches.sh [--restore] <project-dir>
#
# TauCeti publishes the oleans of every main commit to a public Lake artifact cache. Lake only
# reuses them if TauCeti is built here exactly as TauCeti's CI built it, so this script first
# checks that the project pins the same Lean toolchain and Mathlib revision as the pinned TauCeti
# commit, and fails if not. It then downloads the (small) input-to-output mappings for the
# pinned TauCeti revision and writes a Lake configuration naming TauCeti's cache service. Builds
# that run with LAKE_CONFIG pointing at that file and LAKE_ARTIFACT_CACHE=true fetch the TauCeti
# artifacts they need.
#
# With --restore, the script also builds every TauCeti module that a `.lean` file of the project
# imports, restoring the downloaded outputs into TauCeti's build directory, and fails if any
# TauCeti module had to be compiled instead: a cache miss is an error, not a silent rebuild.
# Later builds then find those modules up to date even without the cache settings.
#
# Under GitHub Actions the two settings are appended to $GITHUB_ENV, for later steps. Otherwise,
# and when GITHUB_ENV is unset or empty, stdout is a single `export` line for the caller:
#
#   cache_env="$(bash scripts/fetch_dependency_caches.sh .)" && eval "$cache_env"
#
# (Assign first: `eval "$(...)"` would hide a failure of the script.)
#
# A project whose manifest has no TauCeti package needs nothing, and the script exits cleanly.
# The dependencies must already be checked out (for example by `lake exe cache get`).
set -euo pipefail
# Stdout carries only the final `export` line, so it can be passed to `eval`.
exec 3>&1 1>&2

RESTORE=0
if [ "${1:-}" = "--restore" ]; then
  RESTORE=1
  shift
fi
PROJECT_DIR="$(cd "${1:?usage: fetch_dependency_caches.sh [--restore] <project-dir>}" && pwd)"
ARTIFACT_ENDPOINT="${TAUCETI_ARTIFACT_ENDPOINT:-https://cache.taucetiproject.org/artifacts}"
REVISION_ENDPOINT="${TAUCETI_REVISION_ENDPOINT:-https://cache.taucetiproject.org/revisions}"

manifest_rev() {
  # manifest_rev <lake-manifest.json> <package>: the pinned rev, or nothing.
  python3 - "$1" "$2" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    packages = json.load(f)["packages"]
print(next((p["rev"] for p in packages if p["name"] == sys.argv[2]), ""))
PY
}

TAUCETI_REV="$(manifest_rev "$PROJECT_DIR/lake-manifest.json" TauCeti)"
if [ -z "$TAUCETI_REV" ]; then
  echo "fetch_dependency_caches: no TauCeti package in the manifest; nothing to fetch"
  exit 0
fi

TAUCETI_DIR="$PROJECT_DIR/.lake/packages/TauCeti"
if [ ! -f "$TAUCETI_DIR/lake-manifest.json" ]; then
  echo "::error::fetch_dependency_caches: $TAUCETI_DIR is not checked out; fetch the dependencies first"
  exit 1
fi

# TauCeti's published outputs are keyed by the toolchain and by the traces of the Mathlib it was
# built against, so any difference here turns every lookup into a miss and a full rebuild.
ours_toolchain="$(tr -d '[:space:]' < "$PROJECT_DIR/lean-toolchain")"
their_toolchain="$(tr -d '[:space:]' < "$TAUCETI_DIR/lean-toolchain")"
ours_mathlib="$(manifest_rev "$PROJECT_DIR/lake-manifest.json" mathlib)"
their_mathlib="$(manifest_rev "$TAUCETI_DIR/lake-manifest.json" mathlib)"
if [ "$ours_toolchain" != "$their_toolchain" ] || [ "$ours_mathlib" != "$their_mathlib" ]; then
  echo "::error::fetch_dependency_caches: TauCeti $TAUCETI_REV was built with $their_toolchain and Mathlib $their_mathlib, but this project pins $ours_toolchain and Mathlib $ours_mathlib. Pin the same toolchain and Mathlib as the TauCeti commit so its build cache applies."
  exit 1
fi

CONFIG="$(mktemp "${RUNNER_TEMP:-${TMPDIR:-/tmp}}/lean-eval-dependency-cache.XXXXXX")"
python3 - "$CONFIG" "$ARTIFACT_ENDPOINT" "$REVISION_ENDPOINT" <<'PY'
import json, sys
path, artifacts, revisions = sys.argv[1:]
with open(path, "w", encoding="utf-8") as f:
    # JSON strings are valid TOML basic strings.
    f.write('cache.defaultService = "tauceti-public"\n')
    f.write('[[cache.service]]\n')
    f.write('name = "tauceti-public"\n')
    f.write('kind = "s3"\n')
    f.write(f"artifactEndpoint = {json.dumps(artifacts)}\n")
    f.write(f"revisionEndpoint = {json.dumps(revisions)}\n")
PY

fetched=0
for attempt in 1 2 3; do
  if (cd "$PROJECT_DIR" && LAKE_CONFIG="$CONFIG" lake cache get --service tauceti-public \
        --repo TauCetiProject/TauCeti --package TauCeti --rev "$TAUCETI_REV" --mappings-only); then
    fetched=1
    break
  fi
  echo "::notice::fetching TauCeti's cache mappings failed (attempt $attempt of 3)"
  sleep 5
done
if [ "$fetched" != 1 ]; then
  echo "::error::fetch_dependency_caches: could not fetch TauCeti's cache mappings for $TAUCETI_REV"
  exit 1
fi

if [ "$RESTORE" = 1 ]; then
  # Every TauCeti module a `.lean` file of the project (outside .lake) imports, one per line.
  # Lean's header syntax is `[public] [meta] import [all] Module`; a file that cannot be read
  # makes this fail rather than silently restore less.
  modules="$(python3 - "$PROJECT_DIR" <<'PY'
import pathlib, re, sys
root = pathlib.Path(sys.argv[1])
pattern = re.compile(
    r"^\s*(?:public\s+)?(?:meta\s+)?import\s+(?:all\s+)?(TauCeti(?:\.[^\s.-]+)*)", re.M)
found = set()
for path in root.rglob("*.lean"):
    if ".lake" in path.relative_to(root).parts:
        continue
    found.update(pattern.findall(path.read_text(encoding="utf-8")))
print("\n".join(sorted(found)))
PY
)"
  if [ -n "$modules" ]; then
    count="$(printf '%s\n' "$modules" | wc -l)"
    echo "fetch_dependency_caches: restoring $count imported TauCeti module(s) and their dependencies"
    log="$(mktemp)"
    # shellcheck disable=SC2086 # one module name per word; names contain no whitespace
    if ! (cd "$PROJECT_DIR" && LAKE_CONFIG="$CONFIG" LAKE_ARTIFACT_CACHE=true \
          LAKE_RESTORE_ARTIFACTS=true lake build $modules) > "$log" 2>&1; then
      tail -n 50 "$log"
      echo "::error::fetch_dependency_caches: building TauCeti from its cache failed"
      exit 1
    fi
    compiled="$(grep -cE 'Built TauCeti(\.|$| )' "$log" || true)"
    if [ "$compiled" != 0 ]; then
      grep -m 20 -E 'Built TauCeti(\.|$| )' "$log" || true
      echo "::error::fetch_dependency_caches: $compiled TauCeti module(s) were compiled instead of downloaded; TauCeti's cache does not cover this pin"
      exit 1
    fi
  fi
fi

if [ -n "${GITHUB_ENV:-}" ]; then
  {
    echo "LAKE_CONFIG=$CONFIG"
    echo "LAKE_ARTIFACT_CACHE=true"
  } >> "$GITHUB_ENV"
else
  printf 'export LAKE_CONFIG=%q LAKE_ARTIFACT_CACHE=true\n' "$CONFIG" >&3
fi
