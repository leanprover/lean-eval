#!/usr/bin/env python3
"""Fail if the pinned `lean-toolchain` is a string the evaluation pipeline rejects.

The benchmark owns the toolchain pin, but the submissions pipeline, the Worker
and the State ledger each validate the toolchain string against their own
contracts. A pin they reject (as `v4.35.0-rc3` was before 2026-10-07) breaks
every server-dispatched evaluation while the benchmark's own CI stays green.

This check fetches the live contracts from the protected `main` branches and
matches the pin against every toolchain pattern they carry, plus the shared
acceptance vectors in State. It needs the network and runs in the classify job
of CI, which has no Lean build to hide behind.
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
CONTRACTS = (
    ("leanprover/lean-eval-submissions", "schemas/evaluation-completion-v1.schema.json"),
    ("leanprover/lean-eval-submissions", "schemas/replay-queue-v1.schema.json"),
    ("leanprover/lean-eval-state", "schema/state-event-v1.schema.json"),
    ("leanprover/lean-eval-state", "schema/submission-view-v2.schema.json"),
)
VECTORS = ("leanprover/lean-eval-state", "schema/toolchain-vectors-v1.json")
MAX_BYTES = 1 << 20


class ContractError(Exception):
    pass


def fetch(base_url: str, repository: str, path: str) -> object:
    url = f"{base_url}/{repository}/main/{path}"
    with urllib.request.urlopen(url, timeout=30) as response:  # noqa: S310 -- fixed https/file base
        raw = response.read(MAX_BYTES + 1)
    if len(raw) > MAX_BYTES:
        raise ContractError(f"{url} is larger than {MAX_BYTES} bytes")
    try:
        return json.loads(raw.decode("utf-8"))
    except (UnicodeDecodeError, ValueError) as error:
        raise ContractError(f"{url} is not JSON: {error}") from error


def toolchain_patterns(document: object) -> list[tuple[str, str]]:
    found: list[tuple[str, str]] = []

    def walk(node: object, path: str) -> None:
        if isinstance(node, dict):
            pattern = node.get("pattern")
            if isinstance(pattern, str) and "lean4:v" in pattern:
                found.append((path, pattern))
            for key, value in node.items():
                walk(value, f"{path}/{key}")
        elif isinstance(node, list):
            for index, value in enumerate(node):
                walk(value, f"{path}[{index}]")

    walk(document, "")
    return found


def check(toolchain: str, base_url: str) -> list[str]:
    """Return the contract violations for `toolchain` (empty means accepted)."""
    violations: list[str] = []
    checked = 0
    for repository, path in CONTRACTS:
        document = fetch(base_url, repository, path)
        patterns = toolchain_patterns(document)
        if not patterns:
            raise ContractError(f"{repository}/{path} carries no toolchain pattern")
        for pointer, pattern in patterns:
            checked += 1
            if re.fullmatch(pattern, toolchain) is None:
                violations.append(f"{repository}/{path}{pointer} rejects {toolchain!r} ({pattern})")
    vectors = fetch(base_url, *VECTORS)
    if not isinstance(vectors, dict) or vectors.get("schema_version") != 1:
        raise ContractError("toolchain vectors have an unexpected schema")
    if toolchain in vectors["rejected"]:
        violations.append(f"{VECTORS[0]}/{VECTORS[1]} lists {toolchain!r} as rejected")
    if checked == 0:
        raise ContractError("no toolchain pattern was checked")
    return violations


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--toolchain-file", type=pathlib.Path, default=ROOT / "lean-toolchain")
    parser.add_argument("--base-url", default=DEFAULT_BASE_URL,
                        help="prefix before <repository>/main/<path> (tests use a file:// tree)")
    args = parser.parse_args(argv)
    toolchain = args.toolchain_file.read_text(encoding="utf-8").strip()
    if not toolchain:
        print("lean-toolchain is empty", file=sys.stderr)
        return 1
    try:
        violations = check(toolchain, args.base_url.rstrip("/"))
    except (ContractError, OSError) as error:
        print(f"cannot check the pipeline toolchain contract: {error}", file=sys.stderr)
        return 2
    if violations:
        print(f"the pinned toolchain {toolchain!r} is rejected by the evaluation pipeline:",
              file=sys.stderr)
        for violation in violations:
            print(f"  - {violation}", file=sys.stderr)
        print("Widen the contracts (readers first) before bumping lean-toolchain.", file=sys.stderr)
        return 1
    print(f"{toolchain} is accepted by every pipeline toolchain contract")
    return 0


if __name__ == "__main__":
    sys.exit(main())
