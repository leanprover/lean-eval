#!/usr/bin/env bash
# Prepare a lean-eval checkout (or anything that reuses its .lake/packages) to download
# TauCeti's build outputs instead of compiling TauCeti.
#
# Usage: bash scripts/fetch_dependency_caches.sh <project-dir>
#
# TauCeti publishes the oleans of every main commit to a public Lake artifact cache. Lake only
# reuses them if TauCeti is built here exactly as TauCeti's CI built it, so this script first
# checks that the project pins the same Lean toolchain and Mathlib revision as the pinned TauCeti
# commit, and fails if not. It then downloads the (small) input-to-output mappings for the
# pinned TauCeti revision and writes a Lake configuration naming TauCeti's cache service. Builds
# that run with LAKE_CONFIG pointing at that file and LAKE_ARTIFACT_CACHE=true fetch exactly the
# TauCeti artifacts they need. Under GitHub Actions both variables are appended to $GITHUB_ENV;
# elsewhere they are printed for the caller to export.
#
# A project whose manifest has no TauCeti package needs nothing, and the script exits cleanly.
# The dependencies must already be checked out (for example by `lake exe cache get`).
set -euo pipefail
# Stdout carries only the final `export` line (see below), so it can be passed to `eval`.
exec 3>&1 1>&2

PROJECT_DIR="$(cd "${1:?usage: fetch_dependency_caches.sh <project-dir>}" && pwd)"
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

CONFIG="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/lean-eval-dependency-cache.toml"
cat > "$CONFIG" <<TOML
cache.defaultService = "tauceti-public"
[[cache.service]]
name = "tauceti-public"
kind = "s3"
artifactEndpoint = "$ARTIFACT_ENDPOINT"
revisionEndpoint = "$REVISION_ENDPOINT"
TOML

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

if [ -n "${GITHUB_ENV:-}" ]; then
  {
    echo "LAKE_CONFIG=$CONFIG"
    echo "LAKE_ARTIFACT_CACHE=true"
  } >> "$GITHUB_ENV"
else
  echo "export LAKE_CONFIG=$CONFIG LAKE_ARTIFACT_CACHE=true" >&3
fi
