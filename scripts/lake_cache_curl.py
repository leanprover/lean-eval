#!/usr/bin/env python3
"""Retry Lake's downloads without exposing partial files as cached artifacts.

Use this executable as CURL only while preparing trusted dependencies. Lake's
single-file downloader otherwise writes directly to the content-addressed path
and may reuse a partial file after a failed transfer. Other curl invocations
(including Lake's separately managed parallel transfers) pass through unchanged.
"""

from __future__ import annotations

import os
import pathlib
import subprocess
import sys
import tempfile


def download(args: list[str]) -> int:
    # This is the argument shape emitted by Lake.Build.Actions.download.
    # Do not reinterpret parallel/config-file requests or uploads as downloads.
    if args[:4] != ["-s", "-S", "-f", "-o"] or len(args) < 7:
        return subprocess.run(["curl", *args], check=False).returncode
    destination = pathlib.Path(args[4])
    descriptor, temporary = tempfile.mkstemp(
        prefix=f".{destination.name}.", suffix=".download", dir=destination.parent
    )
    os.close(descriptor)
    try:
        result = subprocess.run(
            [
                "curl",
                "--retry", "3",
                "--retry-all-errors",
                "--connect-timeout", "15",
                "--max-time", "120",
                "--retry-max-time", "240",
                *args[:4], temporary, *args[5:],
            ],
            check=False,
        )
        if result.returncode == 0:
            os.replace(temporary, destination)
        return result.returncode
    finally:
        pathlib.Path(temporary).unlink(missing_ok=True)


def main() -> int:
    try:
        return download(sys.argv[1:])
    except OSError as exc:
        print(f"lake_cache_curl: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
