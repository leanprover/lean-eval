#!/usr/bin/env python3
"""Check the production harness keeps using trusted tools after elaboration."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[2]
SUBMISSION = r'''import Lean

initialize do
  let binDir : System.FilePath := ".lake/build/bin"
  IO.FS.createDirAll binDir
  for name in #["landrun", "lean4export", "nanoda_bin", "lean", "ldconfig", "lake", "git", "which"] do
    let path := binDir / name
    IO.FS.writeFile path "#!/bin/sh\nprintf 'unexpected tool lookup\n' > .lake/tool-shadow-used\nexit 73\n"
    IO.setAccessRights path {
      user := { read := true, write := true, execution := true }
    }
  IO.FS.writeFile ".lake/tool-shadow-planted" "done\n"

namespace Submission
theorem target : True := True.intro
end Submission
'''


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-tools", action="store_true")
    args = parser.parse_args()
    missing = [name for name in ("lake", "lean", "comparator", "landrun", "lean4export", "nanoda_bin")
               if shutil.which(name) is None]
    if missing:
        message = f"Missing tools: {', '.join(missing)}"
        if args.require_tools:
            raise SystemExit(message)
        print(f"SKIP: {message}")
        return
    with tempfile.TemporaryDirectory(prefix="trusted-tool-probe-") as tmp:
        workspace = Path(tmp)
        files = {
            "lean-toolchain": (ROOT / "lean-toolchain").read_text(encoding="utf-8"),
            "lakefile.toml": 'name = "tool_path_probe"\ntestDriver = "workspace_test"\n'
                '[[lean_lib]]\nname = "Challenge"\n'
                '[[lean_lib]]\nname = "Solution"\n'
                '[[lean_lib]]\nname = "Submission"\n'
                '[[lean_exe]]\nname = "workspace_test"\nroot = "WorkspaceTest"\n',
            "WorkspaceTest.lean": (ROOT / "templates/WorkspaceTest.lean").read_text(encoding="utf-8"),
            "Challenge.lean": "theorem target : True := True.intro\n",
            "Submission.lean": SUBMISSION,
            "Solution.lean": "import Submission\ntheorem target : True := Submission.target\n",
            "config.json": json.dumps({
                "challenge_module": "Challenge", "solution_module": "Solution",
                "theorem_names": ["target"],
                "permitted_axioms": ["propext", "Quot.sound", "Classical.choice"],
            }) + "\n",
        }
        for name, content in files.items():
            (workspace / name).write_text(content, encoding="utf-8")
        result = subprocess.run(
            ["lake", "test"], cwd=workspace, capture_output=True, text=True, timeout=300,
        )
        print(result.stdout, end="")
        print(result.stderr, end="")
        if not (workspace / ".lake/tool-shadow-planted").is_file():
            raise SystemExit("FAIL: submission did not create the tool stand-ins")
        if (workspace / ".lake/tool-shadow-used").exists():
            raise SystemExit("FAIL: a workspace tool stand-in was executed")
        if result.returncode != 0:
            raise SystemExit(f"FAIL: valid proof was rejected (exit {result.returncode})")
        print("PASS: trusted tools and both kernels accepted after workspace tools were created")


if __name__ == "__main__":
    main()
