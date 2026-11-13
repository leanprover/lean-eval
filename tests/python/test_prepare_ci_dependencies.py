from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("prepare_ci_dependencies",
                                            ROOT / "scripts/prepare_ci_dependencies.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class PrepareCIDependenciesTests(unittest.TestCase):
    def test_pinned_metadata_is_real_and_solution_sources_are_not_materialized(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "source"
            source.mkdir()
            subprocess.run(["git", "init", "--quiet", "--initial-branch=main", str(source)], check=True)
            subprocess.run(["git", "-C", str(source), "config", "uploadpack.allowFilter", "true"], check=True)
            (source / "lakefile.toml").write_text('name = "example"\n')
            (source / "lake-manifest.json").write_text('{"packages": []}\n')
            (source / "lean-toolchain").write_text("leanprover/lean4:v4.35.0\n")
            (source / "Example.lean").write_text("def largeSolutionLibrary := 42\n")
            subprocess.run(["git", "-C", str(source), "add", "."], check=True)
            subprocess.run(["git", "-C", str(source), "-c", "user.name=Tests", "-c",
                            "user.email=tests@example.invalid", "commit", "--quiet", "-m", "fixture"],
                           check=True)
            revision = subprocess.check_output(["git", "-C", str(source), "rev-parse", "HEAD"],
                                               text=True).strip()
            (root / "solution-dependencies.json").write_text(json.dumps([
                {"name": name} for name in MODULE.PACKAGES]))
            (root / "lake-manifest.json").write_text(json.dumps({"packages": [
                {"name": name, "url": str(source), "rev": revision} for name in MODULE.PACKAGES]}))
            MODULE.prepare(root)
            for name in MODULE.PACKAGES:
                package = root / ".lake/packages" / name
                self.assertEqual((package / "lakefile.toml").read_bytes(),
                                 (source / "lakefile.toml").read_bytes())
                self.assertFalse((package / "Example.lean").exists())
                self.assertEqual(subprocess.check_output(
                    ["git", "-C", str(package), "rev-parse", "HEAD"], text=True).strip(), revision)
            with self.assertRaisesRegex(ValueError, "fresh CI checkout"):
                MODULE.prepare(root)

    def test_only_solution_only_packages_may_have_their_sources_omitted(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "solution-dependencies.json").write_text("[]")
            with self.assertRaisesRegex(ValueError, "trusted statement imports"):
                MODULE.prepare(root)


if __name__ == "__main__":
    unittest.main()
