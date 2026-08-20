from __future__ import annotations

import importlib.util
import json
import pathlib
import sys
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("v1_audit", ROOT / "scripts" / "v1_audit.py")
assert SPEC is not None and SPEC.loader is not None
AUDIT = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = AUDIT
SPEC.loader.exec_module(AUDIT)


class V1AuditTest(unittest.TestCase):
    def test_v1_and_v2_records_produce_deterministic_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            results = pathlib.Path(directory)
            (results / "v1.json").write_text(json.dumps({
                "schema_version": 1,
                "user": "alice",
                "solved": {"Model A": {"alpha": {
                    "solved_at": "2026-01-01T00:00:00Z",
                    "issue_number": 7,
                    "submission_public": True,
                }}},
            }), encoding="utf-8")
            (results / "v2.json").write_text(json.dumps({
                "schema_version": 2,
                "user": "bob",
                "results": [{
                    "problem_id": "alpha",
                    "declared_model": "Model B",
                    "accepted_at": "2026-02-01T00:00:00Z",
                    "intake": {"kind": "server"},
                    "submission": {"public": False},
                }],
            }), encoding="utf-8")
            records, file_count = AUDIT.load_records(results)
            report = AUDIT.build_report({"alpha": {
                "title": "Alpha",
                "group": "formalization-evaluation",
                "status": "draft",
                "visible": True,
                "statement_revision": 1,
                "tags": [],
            }}, records, file_count)
            row = report["problems"][0]
            self.assertEqual(report["result_record_count"], 2)
            self.assertEqual(row["solve_count"], 2)
            self.assertEqual(row["unique_model_count"], 2)
            self.assertEqual(row["unique_user_count"], 2)
            self.assertEqual(row["first_accepted_at"], "2026-01-01T00:00:00Z")
            self.assertEqual(row["issue_numbers"], [7])
            self.assertEqual(AUDIT.render_markdown(report), AUDIT.render_markdown(report))

    def test_unknown_problem_is_reported_not_discarded(self):
        report = AUDIT.build_report({}, [{
            "user": "alice",
            "declared_model": "Model A",
            "problem_id": "missing",
            "accepted_at": None,
            "issue_number": None,
            "submission_public": None,
        }], 1)
        self.assertEqual(report["unknown_problem_ids"], ["missing"])
        self.assertFalse(report["problems"][0]["catalog_present"])


if __name__ == "__main__":
    unittest.main()
