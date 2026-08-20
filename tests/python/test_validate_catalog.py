from __future__ import annotations

import importlib.util
import pathlib
import subprocess
import sys
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location(
    "validate_catalog", ROOT / "scripts" / "validate_catalog.py"
)
assert SPEC is not None and SPEC.loader is not None
VALIDATOR = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = VALIDATOR
SPEC.loader.exec_module(VALIDATOR)


TAGS = """\
schema_version = 1

[tags.annals]
label = "Annals Challenge"
description = "Imported from the Annals Challenge."
"""

PROBLEM = """\
id = "alpha"
title = "Alpha"
group = "formalization-evaluation"
status = "draft"
visible = true
statement_revision = 1
tags = ["annals"]
module = "LeanEval.Alpha"
holes = ["alpha"]
submitter = "tester"
"""


class ValidateCatalogTest(unittest.TestCase):
    def make_catalog(self, problem: str = PROBLEM, named_set: str | None = None):
        temporary = tempfile.TemporaryDirectory()
        root = pathlib.Path(temporary.name)
        (root / "manifests" / "problems").mkdir(parents=True)
        (root / "manifests" / "sets").mkdir(parents=True)
        (root / "manifests" / "tags.toml").write_text(TAGS, encoding="utf-8")
        (root / "manifests" / "problems" / "alpha.toml").write_text(
            problem, encoding="utf-8"
        )
        if named_set is not None:
            (root / "manifests" / "sets" / "v1.toml").write_text(
                named_set, encoding="utf-8"
            )
        return temporary, root

    def test_valid_catalog(self):
        temporary, root = self.make_catalog()
        with temporary:
            self.assertEqual(VALIDATOR.validate(root), (1, 1, 0))

    def test_unknown_tag_is_rejected(self):
        temporary, root = self.make_catalog(PROBLEM.replace('"annals"', '"unknown"'))
        with temporary, self.assertRaisesRegex(VALIDATOR.CatalogError, "unregistered tags"):
            VALIDATOR.validate(root)

    def test_revision_history_requires_digest_and_current_revision(self):
        history = PROBLEM.replace("statement_revision = 1", "statement_revision = 2") + """

[[revision_history]]
revision = 2
effective_date = "2026-08-20"
reason = "statement-change"
statement_digest = "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
"""
        temporary, root = self.make_catalog(history)
        with temporary:
            self.assertEqual(VALIDATOR.validate(root), (1, 1, 0))

    def test_frozen_set_member_must_name_a_known_revision(self):
        named_set = """\
schema_version = 1
id = "v1"
title = "LeanEval v1"
frozen = true
published_at = "2026-08-20"
members = [{ problem_id = "alpha", statement_revision = 2 }]
"""
        temporary, root = self.make_catalog(named_set=named_set)
        with temporary, self.assertRaisesRegex(VALIDATOR.CatalogError, "unknown statement revision"):
            VALIDATOR.validate(root)

    def test_frozen_set_membership_cannot_change_from_base(self):
        named_set = """\
schema_version = 1
id = "v1"
title = "LeanEval v1"
frozen = true
published_at = "2026-08-20"
members = [{ problem_id = "alpha", statement_revision = 1 }]
"""
        temporary, root = self.make_catalog(named_set=named_set)
        with temporary:
            subprocess.run(["git", "init", "-q"], cwd=root, check=True)
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                ["git", "-c", "user.name=test", "-c", "user.email=test@example.com",
                 "commit", "-qm", "base"],
                cwd=root,
                check=True,
            )
            path = root / "manifests" / "sets" / "v1.toml"
            path.write_text(named_set.replace(
                'members = [{ problem_id = "alpha", statement_revision = 1 }]',
                "members = []",
            ), encoding="utf-8")
            with self.assertRaisesRegex(VALIDATOR.CatalogError, "membership of a frozen set"):
                VALIDATOR.validate(root, "HEAD")

    def test_status_history_must_end_at_current_status(self):
        history = PROBLEM + """

[[status_history]]
status = "active"
effective_date = "2026-08-20"
reason = "policy"
"""
        temporary, root = self.make_catalog(history)
        with temporary, self.assertRaisesRegex(VALIDATOR.CatalogError, "final status_history"):
            VALIDATOR.validate(root)


if __name__ == "__main__":
    unittest.main()
