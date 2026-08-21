from __future__ import annotations

import importlib.util
import json
import pathlib
import sys
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location(
    "select_ci_problems", ROOT / "scripts" / "select_ci_problems.py"
)
assert SPEC is not None and SPEC.loader is not None
SELECTOR = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = SELECTOR
SPEC.loader.exec_module(SELECTOR)

Change = SELECTOR.Change
Problem = SELECTOR.Problem


class SelectCIProblemsTest(unittest.TestCase):
    def setUp(self) -> None:
        self.problems = (
            Problem("a", "LeanEval.A"),
            Problem("b", "LeanEval.B"),
            Problem("b_second", "LeanEval.B"),
            Problem("c", "LeanEval.C"),
        )
        self.graph = (
            {
                "LeanEval/A.lean": "LeanEval.A",
                "LeanEval/B.lean": "LeanEval.B",
                "LeanEval/C.lean": "LeanEval.C",
                "LeanEval/Helper.lean": "LeanEval.Helper",
            },
            {
                "LeanEval.A": {"LeanEval.Helper"},
                "LeanEval.B": {"LeanEval.A"},
                "LeanEval.C": set(),
                "LeanEval.Helper": set(),
            },
        )

    def select(self, changes, event="pull_request"):
        return SELECTOR.select(ROOT, event, changes, self.problems, self.graph)

    def test_changed_helper_selects_transitive_reverse_dependants(self):
        selection = self.select((Change("M", ("LeanEval/Helper.lean",)),))
        self.assertEqual(selection.mode, "targeted")
        self.assertEqual(selection.problems, ("a", "b", "b_second"))
        self.assertEqual(selection.modules, ("LeanEval.A", "LeanEval.B"))

    def test_shared_module_keeps_all_problems_together(self):
        selection = self.select((Change("M", ("manifests/problems/b.toml",)),))
        self.assertEqual(selection.problems, ("b", "b_second"))
        self.assertEqual(selection.modules, ("LeanEval.B",))

    def test_generated_change_selects_its_problem(self):
        selection = self.select((Change("M", ("generated/c/Challenge.lean",)),))
        self.assertEqual(selection.problems, ("c",))
        self.assertTrue(selection.generated_changed)

    def test_generated_index_change_runs_checks_without_a_catalog_shard(self):
        selection = self.select((Change("M", ("generated/index.json",)),))
        self.assertEqual(selection.problems, ())
        self.assertFalse(selection.run_catalog)
        self.assertTrue(selection.generated_changed)
        self.assertTrue(selection.run_checks)

    def test_generator_change_is_a_full_catalog_sentinel(self):
        selection = self.select((Change("M", ("EvalTools/Generate.lean",)),))
        self.assertEqual(selection.mode, "full")
        self.assertEqual(selection.problems, ("a", "b", "b_second", "c"))

    def test_tag_registry_change_is_a_full_catalog_sentinel(self):
        selection = self.select((Change("M", ("manifests/tags.toml",)),))
        self.assertEqual(selection.mode, "full")
        self.assertEqual(selection.problems, ("a", "b", "b_second", "c"))

    def test_named_set_change_is_a_full_catalog_sentinel(self):
        selection = self.select((Change("A", ("manifests/sets/v1.toml",)),))
        self.assertEqual(selection.mode, "full")
        self.assertEqual(selection.problems, ("a", "b", "b_second", "c"))

    def test_deleted_source_falls_back_to_full_catalog(self):
        selection = self.select((Change("D", ("LeanEval/Helper.lean",)),))
        self.assertEqual(selection.mode, "full")

    def test_docs_only_change_selects_no_catalog_work(self):
        selection = self.select((Change("M", ("README.md",)),))
        self.assertEqual(selection.mode, "none")
        self.assertFalse(selection.run_catalog)

    def test_deleted_doc_still_selects_no_catalog_work(self):
        selection = self.select((Change("D", ("docs/old.md",)),))
        self.assertEqual(selection.mode, "none")

    def test_deleted_generated_file_selects_its_workspace(self):
        selection = self.select((Change("D", ("generated/c/README.md",)),))
        self.assertEqual(selection.mode, "targeted")
        self.assertEqual(selection.problems, ("c",))

    def test_push_always_selects_full_catalog(self):
        selection = self.select((Change("M", ("README.md",)),), event="push")
        self.assertEqual(selection.mode, "full")
        self.assertEqual(len(selection.problems), 4)

    def test_matrix_balances_by_problem_and_preserves_modules(self):
        selection = self.select((Change("M", ("EvalTools/Generate.lean",)),))
        matrix = SELECTOR.make_matrix(selection, self.problems, 2)["include"]
        self.assertEqual(len(matrix), 2)
        locations = {}
        for shard in matrix:
            for problem in shard["problems"].split(","):
                locations[problem] = shard["shard"]
        self.assertEqual(locations["b"], locations["b_second"])
        self.assertEqual(set(locations), {"a", "b", "b_second", "c"})

    def test_empty_matrix_has_a_placeholder_for_github_validation(self):
        selection = self.select((Change("M", ("README.md",)),))
        self.assertEqual(
            SELECTOR.make_matrix(selection, self.problems, 8),
            {"include": [
                {"shard": 0, "shard_count": 1, "problems": "", "modules": ""}
            ]},
        )

    def test_nul_git_changes_preserve_unicode_and_rename_paths(self):
        changes = SELECTOR.parse_git_changes(
            "M\0LeanEval/Über.lean\0R100\0LeanEval/Old.lean\0"
            "LeanEval/New.lean\0".encode()
        )
        self.assertEqual(
            changes,
            (
                Change("M", ("LeanEval/Über.lean",)),
                Change("R100", ("LeanEval/Old.lean", "LeanEval/New.lean")),
            ),
        )

    def test_nul_git_changes_reject_truncated_records(self):
        with self.assertRaisesRegex(ValueError, "unexpected git diff record"):
            SELECTOR.parse_git_changes(b"R100\0LeanEval/Old.lean\0")

    def test_loads_graph_emitted_by_lean(self):
        payload = [
            {
                "path": "LeanEval/A.lean",
                "module": "LeanEval.A",
                "imports": ["Mathlib", "LeanEval.Helper"],
            },
            {
                "path": "LeanEval/Helper.lean",
                "module": "LeanEval.Helper",
                "imports": [],
            },
        ]
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "import-graph.json"
            path.write_text(json.dumps(payload), encoding="utf-8")
            paths, imports = SELECTOR.load_import_graph(path)
        self.assertEqual(paths["LeanEval/A.lean"], "LeanEval.A")
        self.assertEqual(imports["LeanEval.A"], {"LeanEval.Helper"})
        self.assertEqual(imports["LeanEval.Helper"], set())


if __name__ == "__main__":
    unittest.main()
