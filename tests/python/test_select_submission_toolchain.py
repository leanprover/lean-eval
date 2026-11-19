from __future__ import annotations

import importlib.util
import io
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tarfile
import tempfile
import unittest
from unittest import mock


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
SPEC = importlib.util.spec_from_file_location("select_submission_toolchain",
                                            ROOT / "scripts/select_submission_toolchain.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class SelectSubmissionToolchainTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        (self.root / "manifests/problems").mkdir(parents=True)
        for problem in ("a", "b"):
            (self.root / f"manifests/problems/{problem}.toml").write_text("")
            (self.root / f"generated/{problem}").mkdir(parents=True)
            (self.root / f"generated/{problem}/Submission.lean").write_text("-- stub\n")
        for relative, pin in [("rc", "v4.36.0-rc2"), ("stable", "v4.35.0")]:
            profile = self.root / relative
            profile.mkdir()
            for name in ["lean-toolchain", "lakefile.toml", "lake-manifest.json"]:
                (profile / name).write_text("leanprover/lean4:" + pin if name == "lean-toolchain" else "{}")
        (self.root / "supported-toolchains.json").write_text(json.dumps({
            "default": "leanprover/lean4:v4.36.0-rc2", "stable": "leanprover/lean4:v4.35.0",
            "configurations": {
                "leanprover/lean4:v4.36.0-rc2": "rc", "leanprover/lean4:v4.35.0": "stable"}}))

    def archive(self, files):
        archive = self.root / "source.tar.gz"
        with tarfile.open(archive, "w:gz") as output:
            for name, value in files:
                member = tarfile.TarInfo(name)
                if value is None:
                    member.type = tarfile.SYMTYPE
                    member.linkname = "/etc/passwd"
                    output.addfile(member)
                else:
                    data = value.encode()
                    member.size = len(data)
                    output.addfile(member, io.BytesIO(data))
        return archive

    def workspace(self, problem="a", prefix="source/generated/a"):
        return [(prefix + "/lakefile.toml", f'name = "{problem}"'),
                (prefix + "/Submission.lean", "-- proof\n")]

    def test_root_pin_and_nearest_workspace_pin_select_approved_configurations(self):
        files = [("source/lean-toolchain", "leanprover/lean4:v4.35.0")] + self.workspace()
        selected, problems = MODULE.select(self.archive(files), self.root)
        self.assertEqual(selected, "leanprover/lean4:v4.35.0")
        self.assertEqual(problems, ["a"])
        files.append(("source/generated/a/lean-toolchain", "leanprover/lean4:v4.36.0-rc2"))
        self.assertEqual(MODULE.select(self.archive(files), self.root)[0],
                         "leanprover/lean4:v4.36.0-rc2")

    def test_pristine_workspaces_and_other_selected_problems_do_not_choose_toolchains(self):
        files = self.workspace() + [("source/generated/a/lean-toolchain", "leanprover/lean4:v4.35.0")]
        files += self.workspace("b", "source/generated/b")
        files += [("source/generated/b/lean-toolchain", "leanprover/lean4:v4.36.0-rc2")]
        archive = self.archive(files)
        with self.assertRaisesRegex(ValueError, "one toolchain"):
            MODULE.select(archive, self.root)
        self.assertEqual(MODULE.select(archive, self.root, "a")[0], "leanprover/lean4:v4.35.0")
        files = [(path, "-- stub\n" if path == "source/generated/b/Submission.lean" else content)
                 for path, content in files]
        self.assertEqual(MODULE.select(self.archive(files), self.root)[1], ["a"])

    def test_an_implicit_and_explicit_default_are_the_same_configuration(self):
        files = self.workspace() + self.workspace("a", "source/another-a")
        files.append(("source/another-a/lean-toolchain", "leanprover/lean4:v4.36.0-rc2"))
        self.assertEqual(MODULE.select(self.archive(files), self.root),
                         ("leanprover/lean4:v4.36.0-rc2", ["a"]))

    def test_unsupported_pins_escaping_paths_symlinks_and_duplicates_fail_closed(self):
        cases = [self.workspace() + [("source/lean-toolchain", "leanprover/lean4:nightly")],
                 [("../lean-toolchain", "ignored")], self.workspace() + [("source/lean-toolchain", None)],
                 [("source/lean-toolchain", "a"), ("source/lean-toolchain", "b")],
                 self.workspace() + [("source/lean-toolchain", "a" * 257)]]
        for files in cases:
            with self.subTest(files=files), self.assertRaises(ValueError):
                MODULE.select(self.archive(files), self.root)

    def test_archive_retains_unsupported_requests_but_evaluation_rejects_them(self):
        scripts = self.root / "scripts"
        scripts.mkdir()
        for name in ["prepare_toolchain.py", "select_submission_toolchain.py"]:
            shutil.copyfile(ROOT / "scripts" / name, scripts / name)
        archive = self.archive(self.workspace() + [
            ("source/lean-toolchain", "leanprover/lean4:nightly")])
        command = [sys.executable, str(scripts / "select_submission_toolchain.py"),
                   "--source-tar", str(archive)]
        archived = subprocess.run([*command, "--archive"], capture_output=True, text=True)
        self.assertEqual(archived.returncode, 0, archived.stderr)
        self.assertEqual(archived.stdout.strip(), "leanprover/lean4:v4.36.0-rc2")
        evaluated = subprocess.run([*command, "--expected", archived.stdout.strip()],
                                   capture_output=True, text=True)
        self.assertNotEqual(evaluated.returncode, 0)
        self.assertIn("unsupported requested toolchain", evaluated.stderr)

    def test_parser_recursion_is_an_input_rejection_and_unused_symlinks_are_ignored(self):
        with mock.patch.object(MODULE, "source_requests", side_effect=RecursionError("nested TOML")):
            with self.assertRaises(MODULE.ToolchainRequestError):
                MODULE.select(self.root / "source.tar.gz", self.root)
        files = self.workspace() + [("source/lean-toolchain", "leanprover/lean4:v4.35.0"),
                                    ("source/vendor/lakefile.toml", None),
                                    ("source/vendor/lean-toolchain", None)]
        self.assertEqual(MODULE.select(self.archive(files), self.root)[0], "leanprover/lean4:v4.35.0")


if __name__ == "__main__":
    unittest.main()
