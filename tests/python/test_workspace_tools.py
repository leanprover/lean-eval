"""Exercise the real WorkspaceTest executable with harmless tool stand-ins."""

from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
OVERRIDES = {
    "COMPARATOR_BIN": "comparator",
    "COMPARATOR_LANDRUN": "landrun",
    "COMPARATOR_LEAN4EXPORT": "lean4export",
    "COMPARATOR_NANODA": "nanoda_bin",
}


def executable(path: Path, content: str) -> None:
    path.write_text(content, encoding="utf-8")
    path.chmod(0o755)


class WorkspaceToolsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.temp = tempfile.TemporaryDirectory(prefix="workspace-tools-test-")
        cls.addClassCleanup(cls.temp.cleanup)
        cls.base = Path(cls.temp.name).resolve()
        cls.workspace = cls.base / "workspace"
        cls.workspace.mkdir()
        cls.tools = cls.base / "trusted-tools"
        cls.tools.mkdir()
        cls.lake = shutil.which("lake")
        if cls.lake is None:
            raise RuntimeError("lake is required to check WorkspaceTest")
        (cls.workspace / "lean-toolchain").write_text(
            (ROOT / "lean-toolchain").read_text(encoding="utf-8"), encoding="utf-8"
        )
        (cls.workspace / "lakefile.toml").write_text(
            'name = "workspace_tools_test"\ntestDriver = "workspace_test"\n'
            '[[lean_exe]]\nname = "workspace_test"\nroot = "WorkspaceTest"\n',
            encoding="utf-8",
        )
        shutil.copyfile(ROOT / "templates/WorkspaceTest.lean", cls.workspace / "WorkspaceTest.lean")
        (cls.workspace / "config.json").write_text("{}\n", encoding="utf-8")
        for tool in ("landrun", "lean4export", "nanoda_bin"):
            executable(cls.tools / tool, "#!/bin/sh\nexit 0\n")
        # Simulate the supervisor being looked up after new build outputs exist.
        # Both the absolute override and bare PATH lookup must remain trusted.
        executable(
            cls.tools / "comparator",
            f"#!{shutil.which('python3')}\n"
            "import json, os, pathlib, subprocess, sys\n"
            "bins = pathlib.Path('.lake/build/bin')\n"
            "for name in ('landrun', 'lean4export', 'nanoda_bin'):\n"
            "    planted = bins / name\n"
            "    planted.write_text('#!/bin/sh\\nexit 73\\n')\n"
            "    planted.chmod(0o755)\n"
            "future = pathlib.Path('.lake/future-bin')\n"
            "future.mkdir(exist_ok=True)\n"
            "if os.environ.get('TOOL_TEST_FUTURE_DIR'):\n"
            "    pathlib.Path(os.environ['TOOL_TEST_FUTURE_DIR']).mkdir(exist_ok=True)\n"
            "report = {name: os.environ.get(name, '') for name in "
            "('PATH', 'LEAN_PATH', 'LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH', "
            "'COMPARATOR_LANDRUN', 'COMPARATOR_LEAN4EXPORT', 'COMPARATOR_NANODA')}\n"
            "report['nanoda_enabled'] = json.loads(pathlib.Path(sys.argv[1]).read_text())"
            "['enable_nanoda']\n"
            "report['exit_codes'] = [subprocess.run([name]).returncode for name in "
            "('landrun', 'lean4export', "
            "os.environ['COMPARATOR_LANDRUN'])]\n"
            "pathlib.Path('.lake/report.json').write_text(json.dumps(report))\n",
        )
        subprocess.run(
            [cls.lake, "build", "workspace_test"], cwd=cls.workspace, check=True,
            capture_output=True, text=True,
        )

    def environment(self) -> dict[str, str]:
        env = {key: value for key, value in os.environ.items() if key not in OVERRIDES}
        self.bin_dir = self.workspace / ".lake/build/bin"
        self.alias = self.base / "workspace-alias"
        if not self.alias.exists():
            self.alias.symlink_to(self.bin_dir, target_is_directory=True)
        # Include missing paths, empty/relative entries, symlink aliases, and an
        # outside sibling with the same prefix; canonical directory boundaries matter.
        sibling = self.base / "workspace-tools"
        sibling.mkdir(exist_ok=True)
        env["PATH"] = os.pathsep.join([
            str(self.bin_dir), ".lake/build/bin", "", str(self.alias),
            str(self.workspace / ".lake/future-bin"), str(sibling),
            str(self.tools), env["PATH"],
        ])
        for name in ("LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            env[name] = os.pathsep.join([str(self.bin_dir), str(self.alias), str(self.tools)])
        return env

    def run_driver(self, env: dict[str, str]) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [self.lake, "test"], cwd=self.workspace, env=env,
            capture_output=True, text=True, timeout=120,
        )

    def test_search_paths_and_tools_stay_trusted_after_outputs_are_created(self) -> None:
        env = self.environment()
        # Lake prepends its own toolchain binaries. Pin the stand-ins so the
        # test does not accidentally use a real helper installed there.
        env.update({key: str(self.tools / value) for key, value in OVERRIDES.items()})
        result = self.run_driver(env)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads((self.workspace / ".lake/report.json").read_text())
        for name, tool in OVERRIDES.items():
            if name != "COMPARATOR_BIN":
                self.assertEqual(report[name], str(self.tools / tool))
        self.assertEqual(report["exit_codes"], [0, 0, 0])
        self.assertTrue(report["nanoda_enabled"])
        self.assertIn(str(self.workspace / ".lake/build/lib/lean"), report["LEAN_PATH"])
        for name in ("PATH", "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            dirs = [Path(value) for value in report[name].split(os.pathsep)]
            self.assertTrue(all(value.is_absolute() for value in dirs))
            self.assertFalse(any(value.is_relative_to(self.workspace) for value in dirs))
        self.assertIn(str(self.base / "workspace-tools"), report["PATH"].split(os.pathsep))

    def test_explicit_external_overrides_work(self) -> None:
        env = self.environment()
        env.update({key: str(self.tools / value) for key, value in OVERRIDES.items()})
        result = self.run_driver(env)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_default_discovery_ignores_workspace_tools(self) -> None:
        result = self.run_driver(self.environment())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads((self.workspace / ".lake/report.json").read_text())
        self.assertEqual(report["COMPARATOR_LANDRUN"], str(self.tools / "landrun"))
        self.assertEqual(report["COMPARATOR_LEAN4EXPORT"], str(self.tools / "lean4export"))
        self.assertEqual(report["exit_codes"], [0, 0, 0])
        self.assertFalse(Path(report["COMPARATOR_NANODA"]).is_relative_to(self.workspace))

    def test_workspace_overrides_and_external_symlink_aliases_are_rejected(self) -> None:
        self.environment()
        for name, tool in OVERRIDES.items():
            with self.subTest(name=name):
                target = self.bin_dir / ("untrusted-" + tool)
                executable(target, "#!/bin/sh\nexit 73\n")
                alias = self.tools / ("alias-" + tool)
                alias.symlink_to(target)
                for override in (str(target), str(alias)):
                    env = self.environment()
                    env[name] = override
                    result = self.run_driver(env)
                    self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
                    self.assertIn("must point outside the evaluation workspace", result.stderr)

    def test_missing_trusted_tool_fails_before_comparator_starts(self) -> None:
        env = self.environment()
        env["COMPARATOR_LANDRUN"] = str(self.tools / "missing-landrun")
        report = self.workspace / ".lake/report.json"
        report.unlink(missing_ok=True)
        result = self.run_driver(env)
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertIn("Cannot find trusted tool for COMPARATOR_LANDRUN", result.stderr)
        self.assertFalse(report.exists())

    def test_relative_external_overrides_work(self) -> None:
        env = self.environment()
        env.update({key: os.path.relpath(self.tools / value, self.workspace)
                    for key, value in OVERRIDES.items()})
        result = self.run_driver(env)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_relative_and_bare_workspace_overrides_fail(self) -> None:
        for override in (".lake/build/bin/landrun", "workspace-only-landrun"):
            with self.subTest(override=override):
                env = self.environment()
                executable(self.bin_dir / "landrun", "#!/bin/sh\nexit 73\n")
                executable(self.bin_dir / "workspace-only-landrun", "#!/bin/sh\nexit 73\n")
                env["COMPARATOR_LANDRUN"] = override
                result = self.run_driver(env)
                self.assertEqual(result.returncode, 1, result.stdout + result.stderr)

    def test_empty_library_search_paths_are_unset(self) -> None:
        env = self.environment()
        env.update({key: str(self.tools / value) for key, value in OVERRIDES.items()})
        env["LEAN_PATH"] = str(self.workspace / ".lake/build/lib/lean")
        for name in ("LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            env[name] = str(self.bin_dir)
        # Run the compiled driver directly: Lake would add trusted toolchain
        # libraries, preventing these search paths from becoming empty.
        result = subprocess.run(
            [str(self.bin_dir / "workspace_test")], cwd=self.workspace, env=env,
            capture_output=True, text=True, timeout=120,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        report = json.loads((self.workspace / ".lake/report.json").read_text())
        for name in ("LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
            self.assertEqual(report[name], "")

    def test_symlinked_writable_cache_stays_excluded(self) -> None:
        lake_dir = self.workspace / ".lake"
        external_lake = self.base / "external-lake"
        shutil.move(lake_dir, external_lake)
        lake_dir.symlink_to(external_lake, target_is_directory=True)
        try:
            env = self.environment()
            env["PATH"] = str(external_lake / "build/bin") + os.pathsep + env["PATH"]
            result = self.run_driver(env)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            report = json.loads((lake_dir / "report.json").read_text())
            self.assertFalse(any(Path(value).is_relative_to(external_lake)
                                 for value in report["PATH"].split(os.pathsep)))
            env["COMPARATOR_LANDRUN"] = str(external_lake / "build/bin/landrun")
            result = self.run_driver(env)
            self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
            self.assertIn("its writable cache", result.stderr)
        finally:
            lake_dir.unlink()
            shutil.move(external_lake, lake_dir)

    def test_empty_trusted_executable_path_is_rejected(self) -> None:
        env = self.environment()
        env["PATH"] = str(self.bin_dir)
        result = subprocess.run(
            [str(self.bin_dir / "workspace_test")], cwd=self.workspace, env=env,
            capture_output=True, text=True, timeout=120,
        )
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertIn("No trusted executable search directories remain", result.stderr)

    def test_missing_external_search_directory_is_omitted(self) -> None:
        env = self.environment()
        future = self.base / "future-external-tools"
        self.assertFalse(future.exists())
        env["PATH"] = str(future) + os.pathsep + env["PATH"]
        env["TOOL_TEST_FUTURE_DIR"] = str(future)
        result = self.run_driver(env)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertTrue(future.is_dir())
        report = json.loads((self.workspace / ".lake/report.json").read_text())
        self.assertNotIn(str(future), report["PATH"].split(os.pathsep))


if __name__ == "__main__":
    unittest.main()
