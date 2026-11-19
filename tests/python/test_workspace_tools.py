"""Exercise the real trusted test driver with harmless supervisor stand-ins."""

from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


def executable(path: Path, content: str) -> None:
    path.write_text(content)
    path.chmod(0o755)


class WorkspaceToolsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.temp = tempfile.TemporaryDirectory(prefix="workspace-tools-")
        cls.addClassCleanup(cls.temp.cleanup)
        cls.base = Path(cls.temp.name).resolve()
        cls.workspace = cls.base / "workspace"
        cls.workspace.mkdir()
        cls.tools = cls.base / "trusted-tools"
        (cls.tools / "bin").mkdir(parents=True)
        (cls.workspace / "lean-toolchain").write_text((ROOT / "lean-toolchain").read_text())
        (cls.workspace / "lakefile.toml").write_text(
            'name = "workspace_tools_test"\ntestDriver = "workspace_test"\n'
            '[[lean_exe]]\nname = "workspace_test"\nroot = "WorkspaceTest"\n'
        )
        shutil.copyfile(ROOT / "templates/WorkspaceTest.lean", cls.workspace / "WorkspaceTest.lean")
        (cls.workspace / "config.json").write_text(
            '{"enable_nanoda": false, "external_kernels": {}}\n'
        )
        executable(cls.tools / "bin/nanoda_bin", "#!/bin/sh\nexit 0\n")
        executable(
            cls.tools / "bin/lake",
            f"#!{Path(shutil.which('python3')).resolve()}\n"
            "import json, os, pathlib, sys\n"
            "assert sys.argv[1:3] == ['comparator', '--config']\n"
            "report = {name: os.environ.get(name, '') for name in "
            "('PATH', 'LEAN_PATH', 'LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH', 'COMPARATOR_BWRAP')}\n"
            "report['config'] = json.loads(pathlib.Path(sys.argv[3]).read_text())\n"
            "pathlib.Path('.lake/report.json').write_text(json.dumps(report))\n"
            "sys.exit(int(os.environ.get('TOOL_TEST_EXIT', '0')))\n",
        )
        subprocess.run(
            ["lake", "--wfail", "build", "workspace_test"], cwd=cls.workspace,
            check=True, capture_output=True, text=True,
        )
        cls.binary = cls.workspace / ".lake/build/bin/workspace_test"

    def environment(self) -> dict[str, str]:
        env = os.environ.copy()
        bins = self.workspace / ".lake/build/bin"
        alias = self.base / "workspace-alias"
        if not alias.exists():
            alias.symlink_to(bins)
        sibling = self.base / "workspace-tools"
        sibling.mkdir(exist_ok=True)
        env.update({
            "LAKE": str(self.tools / "bin/lake"),
            "LEAN_SYSROOT": str(self.tools),
            "LEAN_PATH": str(self.workspace / ".lake/build/lib/lean"),
            "COMPARATOR_BWRAP": "/trusted/bwrap",
        })
        env["PATH"] = os.pathsep.join([
            str(bins), ".lake/build/bin", "", str(alias),
            str(self.workspace / ".lake/future"), str(sibling), env["PATH"],
        ])
        for name in ("LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            env[name] = os.pathsep.join([str(bins), str(alias), str(self.tools)])
        return env

    def run_driver(self, env: dict[str, str]) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [str(self.binary)], cwd=self.workspace, env=env,
            capture_output=True, text=True, timeout=120,
        )

    def test_filtering_and_kernel_policy(self) -> None:
        result = self.run_driver(self.environment())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads((self.workspace / ".lake/report.json").read_text())
        self.assertFalse(report["config"]["enable_nanoda"])
        self.assertEqual(
            report["config"]["external_kernels"],
            {"nanoda": [str(self.tools / "bin/nanoda_bin")]},
        )
        self.assertEqual(report["COMPARATOR_BWRAP"], "/trusted/bwrap")
        self.assertIn(str(self.workspace / ".lake/build/lib/lean"), report["LEAN_PATH"])
        for name in ("PATH", "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            dirs = [Path(value) for value in report[name].split(os.pathsep)]
            self.assertTrue(all(value.is_absolute() for value in dirs))
            self.assertFalse(any(value.is_relative_to(self.workspace) for value in dirs))
        self.assertIn(str(self.base / "workspace-tools"), report["PATH"].split(os.pathsep))

    def test_workspace_tools_and_external_aliases_are_rejected(self) -> None:
        target = self.workspace / ".lake/build/bin/untrusted-lake"
        executable(target, "#!/bin/sh\nexit 73\n")
        alias = self.tools / "alias-lake"
        alias.symlink_to(target)
        for value in (target, alias):
            with self.subTest(value=value):
                env = self.environment()
                env["LAKE"] = str(value)
                result = self.run_driver(env)
                self.assertEqual(result.returncode, 2)
                self.assertIn("must point outside", result.stderr)

    def test_missing_lake_context_is_setup_failure(self) -> None:
        for name in ("LAKE", "LEAN_SYSROOT"):
            with self.subTest(name=name):
                env = self.environment()
                env.pop(name)
                result = self.run_driver(env)
                self.assertEqual(result.returncode, 2)
                self.assertIn("lake test", result.stderr)

    def test_exit_codes_are_forwarded(self) -> None:
        for code in (1, 2):
            with self.subTest(code=code):
                env = self.environment()
                env["TOOL_TEST_EXIT"] = str(code)
                self.assertEqual(self.run_driver(env).returncode, code)

    def test_empty_paths_are_unset_and_missing_directories_excluded(self) -> None:
        env = self.environment()
        missing = self.base / "future-tools"
        env["PATH"] = str(missing) + os.pathsep + env["PATH"]
        for name in ("LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            env[name] = str(self.workspace / ".lake/build/bin")
        self.assertEqual(self.run_driver(env).returncode, 0)
        report = json.loads((self.workspace / ".lake/report.json").read_text())
        self.assertNotIn(str(missing), report["PATH"].split(os.pathsep))
        for name in ("LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            self.assertEqual(report[name], "")

    def test_symlinked_writable_cache_is_excluded(self) -> None:
        cache = self.workspace / ".lake"
        external = self.base / "external-lake"
        shutil.move(cache, external)
        cache.symlink_to(external)
        try:
            env = self.environment()
            env["PATH"] = str(external / "build/bin") + os.pathsep + env["PATH"]
            self.assertEqual(self.run_driver(env).returncode, 0)
            report = json.loads((cache / "report.json").read_text())
            self.assertFalse(any(Path(value).is_relative_to(external)
                                 for value in report["PATH"].split(os.pathsep)))
        finally:
            cache.unlink()
            shutil.move(external, cache)


if __name__ == "__main__":
    unittest.main()
