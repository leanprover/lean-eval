#!/usr/bin/env python3
"""Check that detached build descendants stop before comparator finishes."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
import tempfile
import time

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from security_probes.common import assert_exit, compare, require_tools, workspace  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-tools", action="store_true")
    args = parser.parse_args()
    if not require_tools(args.require_tools):
        return
    submission = r'''import Lean
initialize do
  IO.FS.createDirAll ".lake/probe"
  let child ← IO.Process.spawn {
    cmd := "setsid"
    args := #["sh", "-c", "while :; do echo tick >> .lake/probe/heartbeat; sleep 0.1; done"]
    stdin := .null
    stdout := .null
    stderr := .null
  }
  let _ := child
  IO.sleep 400
namespace Submission
theorem target : True := True.intro
end Submission
'''
    with tempfile.TemporaryDirectory(prefix="descendant-probe-") as tmp:
        project = workspace(Path(tmp) / "workspace", submission)
        assert_exit(compare(project))
        heartbeat = project / ".lake/probe/heartbeat"
        initial = heartbeat.read_bytes()
        assert initial, "descendant did not start"
        time.sleep(1)
        assert heartbeat.read_bytes() == initial, "descendant survived comparator"
    print("PASS: detached build descendants stop")


if __name__ == "__main__":
    main()
