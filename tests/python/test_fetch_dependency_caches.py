from __future__ import annotations

import json
import os
import pathlib
import shlex
import subprocess
import sys
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts/fetch_dependency_caches.sh"


class FetchDependencyCachesTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = pathlib.Path(directory.name)
        self.project = self.root / "project with spaces"
        package = self.project / ".lake/packages/TauCeti"
        package.mkdir(parents=True)
        manifest = {"packages": [{"name": "TauCeti", "rev": "1" * 40},
                                 {"name": "mathlib", "rev": "2" * 40}]}
        for path in [self.project, package]:
            (path / "lake-manifest.json").write_text(json.dumps(manifest))
            (path / "lean-toolchain").write_text("leanprover/lean4:v4.35.0-rc3\n")
        (self.project / "Main.lean").write_text("import TauCeti.Example\n")
        self.calls = self.root / "calls.jsonl"
        tools = self.root / "bin"
        tools.mkdir()
        (tools / "lake").write_text(
            f"#!{sys.executable}\n"
            "import json,os,sys,pathlib\n"
            f"calls=pathlib.Path({str(self.calls)!r})\n"
            "previous=calls.read_text().splitlines() if calls.exists() else []\n"
            "with calls.open('a') as f: f.write(json.dumps({'args':sys.argv[1:],"
            "'curl':os.environ.get('CURL')})+'\\n')\n"
            "if 'build' in sys.argv:\n"
            " count=sum('build' in json.loads(p)['args'] for p in previous)\n"
            " if count < int(os.environ.get('FAIL_RESTORES','0')):\n"
            "  print('curl: (22) artifact service returned 503')\n"
            "  sys.exit(3)\n"
            " print('Fetched TauCeti.Example')\n"
        )
        (tools / "lake").chmod(0o755)
        (tools / "sleep").write_text("#!/bin/sh\nexit 0\n")
        (tools / "sleep").chmod(0o755)
        self.env = dict(os.environ, PATH=f"{tools}{os.pathsep}{os.environ['PATH']}",
                        GITHUB_ENV="", RUNNER_TEMP=str(self.root))

    def run_script(self, failures):
        return subprocess.run(["bash", str(SCRIPT), "--restore", str(self.project)],
                              env=dict(self.env, FAIL_RESTORES=str(failures)),
                              capture_output=True, text=True, check=False, timeout=10)

    def test_retries_cache_only_restore_and_exports_wrapper_for_later_builds(self):
        result = self.run_script(1)
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = [json.loads(line) for line in self.calls.read_text().splitlines()]
        restores = [c for c in calls if "build" in c["args"]]
        self.assertEqual(len(restores), 2)
        self.assertTrue(all("--no-build" in c["args"] for c in restores))
        wrapper = str(ROOT / "scripts/lake_cache_curl.py")
        self.assertTrue(all(c["curl"] == wrapper for c in calls))
        exports = dict(word.split("=", 1) for word in shlex.split(result.stdout)[1:])
        self.assertEqual(exports["CURL"], wrapper)
        self.assertEqual(exports["LAKE_ARTIFACT_CACHE"], "true")
        self.assertIn("503", result.stderr)

    def test_exhausted_cache_only_restore_fails_without_exporting_settings(self):
        result = self.run_script(2)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertIn("no compilation was permitted", result.stderr)
        calls = [json.loads(line) for line in self.calls.read_text().splitlines()]
        self.assertEqual(sum("build" in c["args"] for c in calls), 2)

    def test_pin_mismatch_stops_before_any_lake_command(self):
        (self.project / "lean-toolchain").write_text("leanprover/lean4:v4.34.0\n")
        result = self.run_script(0)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Pin the same toolchain and Mathlib", result.stderr)
        self.assertFalse(self.calls.exists())


if __name__ == "__main__":
    unittest.main()
