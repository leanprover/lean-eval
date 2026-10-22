#!/usr/bin/env python3
"""Exercise verifier verdicts and mandatory NanoDa through the generated harness."""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import shutil
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
    with tempfile.TemporaryDirectory(prefix="verdict-probe-") as tmp:
        root = Path(tmp)
        valid = workspace(root / "valid")
        result = compare(valid)
        assert_exit(result)
        assert "nanoda kernel accepts the solution" in result.stdout
        assert "Lean default kernel accepts the solution" in result.stdout
        # Fail only the NanoDa sandbox command, leaving all other phases intact.
        real_bwrap = str(Path(shutil.which(os.environ.get("COMPARATOR_BWRAP", "bwrap"))).resolve())
        false = str(Path(shutil.which("false")).resolve())
        wrapper = root / "bwrap-fail-nanoda"
        wrapper.write_text(
            f"#!{Path(sys.executable).resolve()}\nimport os, sys\n"
            "args = sys.argv[1:]\ni = args.index('--')\n"
            f"if args[i + 1].endswith('/nanoda_bin'): args[i + 1:] = [{false!r}]\n"
            f"os.execv({real_bwrap!r}, [{real_bwrap!r}, *args])\n"
        )
        wrapper.chmod(0o755)
        failed = compare(workspace(root / "nanoda-failed"), env={"COMPARATOR_BWRAP": str(wrapper)})
        assert_exit(failed, 1)
        assert "nanoda kernel rejected the solution" in failed.stdout
        assert "Your solution is okay!" not in failed.stdout
        for name, submission, solution in [
            ("sorry", "namespace Submission\ntheorem target : True := by sorry\nend Submission\n", None),
            ("axiom", "namespace Submission\naxiom bad : True\ntheorem target : True := bad\nend Submission\n", None),
            ("mismatch", None, "import Submission\ntheorem target : True ∧ True := ⟨Submission.target, Submission.target⟩\n"),
        ]:
            changes = {}
            if submission is not None:
                changes["submission"] = submission
            if solution is not None:
                changes["solution"] = solution
            assert_exit(compare(workspace(root / name, **changes)), 1)
        for name, challenge, submission, solution, definitions in [
            ("definition", "def foo : Nat := sorry\ntheorem target : foo = 37 := by sorry\n",
             "namespace Submission\ndef foo : Nat := 37\ntheorem target : foo = 37 := rfl\nend Submission\n",
             "import Submission\n@[reducible] def foo : Nat := Submission.foo\ntheorem target : foo = 37 := Submission.target\n",
             ("foo",)),
            ("dependent", "def carrier : Type := sorry\ndef value : carrier := sorry\ntheorem target : value = value := by sorry\n",
             "namespace Submission\nabbrev carrier : Type := Nat\ndef value : carrier := 37\ntheorem target : value = value := rfl\nend Submission\n",
             "import Submission\n@[reducible] def carrier : Type := Submission.carrier\n@[reducible] def value : carrier := Submission.value\ntheorem target : value = value := Submission.target\n",
             ("carrier", "value")),
        ]:
            assert_exit(compare(workspace(root / name, submission, challenge=challenge,
                                          solution=solution, definitions=definitions)))
        missing = workspace(root / "missing-bwrap")
        assert_exit(compare(missing, env={"COMPARATOR_BWRAP": "/no-such-bwrap"}), 2)
    print("PASS: valid and definition proofs accepted by both kernels; invalid proofs rejected")


if __name__ == "__main__":
    main()
