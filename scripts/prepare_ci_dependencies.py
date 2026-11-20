#!/usr/bin/env python3
"""Materialize only package metadata for solution-only CFSG/Stacks CI dependencies.

Trusted problem sources cannot import these packages. Their source trees are
therefore unnecessary for catalog generation, statement builds, and verifier
probes. Lake still reads their real, pinned package configuration and manifest.
This helper is for benchmark CI only; submission preparation uses full sources.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import subprocess
import sys


PACKAGES = frozenset({"cfsg", "Stacks"})
METADATA = ("lakefile.toml", "lakefile.lean", "lake-manifest.json", "lean-toolchain")


def git(directory: Path, *arguments: str) -> None:
    subprocess.run(["git", "-C", str(directory), *arguments], check=True)


def prepare(root: Path) -> None:
    policy = json.loads((root / "solution-dependencies.json").read_text())
    allowed = {entry["name"] for entry in policy}
    if not PACKAGES <= allowed:
        raise ValueError("metadata-only packages must be forbidden in trusted statement imports")
    manifest = json.loads((root / "lake-manifest.json").read_text())
    packages = {p["name"].strip("«»"): p for p in manifest["packages"]}
    for name in sorted(PACKAGES):
        package = packages[name]
        revision = package["rev"]
        if re.fullmatch(r"[0-9a-f]{40}", revision) is None:
            raise ValueError(f"{name} is not pinned to an exact commit")
        destination = root / ".lake/packages" / name
        if destination.exists() or destination.is_symlink():
            raise ValueError(f"expected a fresh CI checkout; {destination} already exists")
        destination.mkdir(parents=True)
        git(destination, "init", "--quiet", "--initial-branch=main")
        git(destination, "remote", "add", "origin", package["url"])
        git(destination, "sparse-checkout", "set", "--no-cone",
            *("/" + name for name in METADATA))
        git(destination, "fetch", "--quiet", "--filter=tree:0", "--depth=1", "--no-tags",
            "origin", revision)
        git(destination, "checkout", "--quiet", "--detach", revision)
        if not (destination / "lake-manifest.json").is_file():
            raise ValueError(f"{name} does not publish its dependency manifest")
        print(f"Prepared {name} package metadata at {revision}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    try:
        prepare(args.root)
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"prepare_ci_dependencies: {error}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
