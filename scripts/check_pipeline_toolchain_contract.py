#!/usr/bin/env python3
"""Fail if the pinned `lean-toolchain` is a string the evaluation pipeline rejects.

The benchmark owns the toolchain pin, but the submissions pipeline, the Worker
and the State ledger each validate the toolchain string against their own
contracts. A pin they reject (as `v4.35.0-rc3` was before 2026-10-07) breaks
every server-dispatched evaluation while the benchmark's own CI stays green.

This check reads the pin exactly as the pipeline does (`$(cat lean-toolchain)`,
so only trailing newlines are dropped), fetches the two live pipeline schemas
and the shared acceptance vectors from the protected `main` branch of
leanprover/lean-eval-submissions, and requires that

- the pin matches the toolchain pattern at each schema's known location,
- the pin is not one of the vectors every contract must reject, and
- each pattern accepts every "accepted" vector and rejects every "rejected"
  one, so a schema that drifted from the shared rule is reported too.

The Worker and the private State repository bind themselves to the same
vectors in their own CI. Patterns must be anchored ECMA-style (`^...$`) and
use only constructs Python's `re` reads the same way; anything else is an
unsupported contract shape and fails closed. It needs the network and runs in
the classify job of CI, which has no Lean build to hide behind.
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import sys
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[1]
DEFAULT_BASE_URL = "https://raw.githubusercontent.com"
PIPELINE = "leanprover/lean-eval-submissions"
# (path in the pipeline repository, JSON pointer of the toolchain pattern)
CONTRACTS = (
    ("schemas/evaluation-completion-v1.schema.json", ("properties", "toolchain", "pattern")),
    ("schemas/replay-queue-v1.schema.json", ("$defs", "task", "properties", "toolchain", "pattern")),
)
VECTORS = "contracts/toolchain-vectors-v1.json"
MAX_BYTES = 1 << 20
ANCHORED = re.compile(r"\^.*\$\Z", re.DOTALL)


class ContractError(Exception):
    pass


def read_pin(path: pathlib.Path) -> str:
    """The pin as the pipeline sees it: `$(cat lean-toolchain)` drops trailing newlines only."""
    return path.read_text(encoding="utf-8").rstrip("\n")


def fetch(base_url: str, path: str) -> object:
    url = f"{base_url}/{PIPELINE}/main/{path}"
    with urllib.request.urlopen(url, timeout=30) as response:  # noqa: S310 -- fixed https/file base
        raw = response.read(MAX_BYTES + 1)
    if len(raw) > MAX_BYTES:
        raise ContractError(f"{url} is larger than {MAX_BYTES} bytes")
    try:
        return json.loads(raw.decode("utf-8"))
    except (UnicodeDecodeError, ValueError) as error:
        raise ContractError(f"{url} is not JSON: {error}") from error


def pattern_at(document: object, pointer: tuple[str, ...], label: str) -> re.Pattern[str]:
    node = document
    for key in pointer:
        if not isinstance(node, dict) or key not in node:
            raise ContractError(f"{label} has no /{'/'.join(pointer)}; unsupported contract shape")
        node = node[key]
    if not isinstance(node, str) or ANCHORED.match(node) is None:
        raise ContractError(f"{label} toolchain pattern is not an anchored string; unsupported contract shape")
    try:
        return re.compile(node)
    except re.error as error:
        raise ContractError(f"{label} toolchain pattern is not readable by Python re: {error}") from error


def load_vectors(base_url: str) -> dict[str, list[str]]:
    vectors = fetch(base_url, VECTORS)
    if not isinstance(vectors, dict) or vectors.get("schema_version") != 1:
        raise ContractError("toolchain vectors have an unexpected schema")
    for key in ("accepted", "rejected"):
        values = vectors.get(key)
        if not isinstance(values, list) or not values or not all(isinstance(v, str) for v in values):
            raise ContractError(f"toolchain vectors {key!r} is not a non-empty list of strings")
    return {"accepted": list(vectors["accepted"]), "rejected": list(vectors["rejected"])}


def check(toolchain: str, base_url: str) -> list[str]:
    """Return the contract violations for `toolchain` (empty means accepted)."""
    vectors = load_vectors(base_url)
    violations: list[str] = []
    if toolchain in vectors["rejected"]:
        violations.append(f"{PIPELINE}/{VECTORS} lists {toolchain!r} as rejected")
    for path, pointer in CONTRACTS:
        label = f"{PIPELINE}/{path}"
        pattern = pattern_at(fetch(base_url, path), pointer, label)
        # `search`, not `fullmatch`: JSON Schema patterns are unanchored unless
        # they say otherwise, and this checker only accepts anchored ones.
        if pattern.search(toolchain) is None:
            violations.append(f"{label} rejects {toolchain!r} ({pattern.pattern})")
        for vector in vectors["accepted"]:
            if pattern.search(vector) is None:
                violations.append(f"{label} rejects the shared accepted vector {vector!r}")
        for vector in vectors["rejected"]:
            if pattern.search(vector) is not None:
                violations.append(f"{label} accepts the shared rejected vector {vector!r}")
    return violations


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--toolchain-file", type=pathlib.Path, default=ROOT / "lean-toolchain")
    parser.add_argument("--base-url", default=DEFAULT_BASE_URL,
                        help="prefix before <repository>/main/<path> (tests use a file:// tree)")
    args = parser.parse_args(argv)
    toolchain = read_pin(args.toolchain_file)
    if not toolchain:
        print("lean-toolchain is empty", file=sys.stderr)
        return 1
    try:
        violations = check(toolchain, args.base_url.rstrip("/"))
    except (ContractError, OSError) as error:
        print(f"cannot check the pipeline toolchain contract: {error}", file=sys.stderr)
        return 2
    if violations:
        print(f"the pinned toolchain {toolchain!r} is not accepted by every pipeline toolchain contract:",
              file=sys.stderr)
        for violation in violations:
            print(f"  - {violation}", file=sys.stderr)
        print("Widen the contracts (readers first) before bumping lean-toolchain.", file=sys.stderr)
        return 1
    print(f"{toolchain} is accepted by every pipeline toolchain contract")
    return 0


if __name__ == "__main__":
    sys.exit(main())
