#!/usr/bin/env python3
"""Check that parent secrets do not reach submission elaboration."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
import tempfile

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
  let value ← IO.getEnv "LEAN_EVAL_PROBE_SECRET"
  IO.FS.writeFile ".lake/probe/secret" (value.getD "absent")
namespace Submission
theorem target : True := True.intro
end Submission
'''
    with tempfile.TemporaryDirectory(prefix="env-probe-") as tmp:
        project = workspace(Path(tmp) / "workspace", submission)
        assert_exit(compare(project, env={"LEAN_EVAL_PROBE_SECRET": "synthetic-secret"}))
        assert (project / ".lake/probe/secret").read_text() == "absent"
    print("PASS: parent secret absent during submission elaboration")


if __name__ == "__main__":
    main()
