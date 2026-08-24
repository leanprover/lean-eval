from __future__ import annotations

import importlib.util
import json
import pathlib
import sys
import tempfile
import textwrap
import unittest
from unittest import mock

ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
SPEC = importlib.util.spec_from_file_location(
    "flavour_text_inventory", ROOT / "scripts" / "flavour_text_inventory.py"
)
assert SPEC is not None and SPEC.loader is not None
INVENTORY = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = INVENTORY
SPEC.loader.exec_module(INVENTORY)


class FlavourTextInventoryTest(unittest.TestCase):
    def _root(self, directory: str) -> pathlib.Path:
        root = pathlib.Path(directory)
        (root / "manifests" / "problems").mkdir(parents=True)
        (root / "manifests" / "tags.toml").write_text(
            "schema_version = 1\n\n[tags]\n", encoding="utf-8"
        )
        return root

    def test_inventory_is_sorted_and_binds_exact_present_prose(self):
        with tempfile.TemporaryDirectory() as directory:
            root = self._root(directory)
            for problem_id, notes in (("beta", None), ("alpha", " Informal statement. ")):
                optional = f'notes = "{notes}"\n' if notes is not None else ""
                (root / "manifests" / "problems" / f"{problem_id}.toml").write_text(
                    textwrap.dedent(
                        f'''\
                        id = "{problem_id}"
                        title = "{problem_id.title()}"
                        module = "LeanEval.{problem_id.title()}"
                        group = "formalization-evaluation"
                        status = "draft"
                        visible = true
                        statement_revision = 1
                        tags = []
                        {optional}source = "Citation"
                        informal_solution = "Proof hint"
                        '''
                    ),
                    encoding="utf-8",
                )

            report = INVENTORY.load_inventory(root)
            self.assertEqual(
                [row["problem_id"] for row in report["problems"]], ["alpha", "beta"]
            )
            self.assertEqual(report["present_counts"]["notes"], 1)
            self.assertEqual(report["all_fields_present_count"], 1)
            alpha = report["problems"][0]
            self.assertEqual(alpha["prose"]["notes"]["character_count"], 21)
            self.assertEqual(alpha["prose"]["notes"]["utf8_byte_count"], 21)
            self.assertRegex(alpha["prose"]["notes"]["sha256"], r"^[0-9a-f]{64}$")
            self.assertEqual(
                INVENTORY.render_markdown(report), INVENTORY.render_markdown(report)
            )

    def test_empty_optional_text_is_missing(self):
        evidence = INVENTORY._field_evidence("  ")
        self.assertTrue(evidence["specified"])
        self.assertFalse(evidence["present"])
        self.assertEqual(evidence["character_count"], 2)
        self.assertRegex(evidence["sha256"], r"^[0-9a-f]{64}$")

    def test_exact_digest_changes_with_boundary_whitespace(self):
        plain = INVENTORY._field_evidence("hint")
        padded = INVENTORY._field_evidence(" hint ")
        self.assertNotEqual(plain["sha256"], padded["sha256"])
        self.assertNotEqual(plain["utf8_byte_count"], padded["utf8_byte_count"])

    def test_filename_mismatch_fails_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = self._root(directory)
            (root / "manifests" / "problems" / "wrong.toml").write_text(
                textwrap.dedent(
                    '''\
                    id = "actual"
                    title = "Actual"
                    module = "LeanEval.Actual"
                    group = "formalization-evaluation"
                    status = "draft"
                    visible = true
                    statement_revision = 1
                    tags = []
                    '''
                ),
                encoding="utf-8",
            )
            with self.assertRaisesRegex(INVENTORY.InventoryError, "match the filename"):
                INVENTORY.load_inventory(root)

    def test_catalog_validator_rejects_unknown_enums(self):
        with tempfile.TemporaryDirectory() as directory:
            root = self._root(directory)
            (root / "manifests" / "problems" / "alpha.toml").write_text(
                textwrap.dedent(
                    '''\
                    id = "alpha"
                    title = "Alpha"
                    module = "LeanEval.Alpha"
                    group = "made-up"
                    status = "draft"
                    visible = true
                    statement_revision = 1
                    tags = []
                    '''
                ),
                encoding="utf-8",
            )
            with self.assertRaisesRegex(INVENTORY.InventoryError, "unknown group"):
                INVENTORY.load_inventory(root)

    def test_emitted_module_must_be_a_non_empty_string(self):
        for label, module_line in (("missing", ""), ("integer", "module = 3\n"),
                                   ("empty", 'module = ""\n')):
            with self.subTest(label=label), tempfile.TemporaryDirectory() as directory:
                root = self._root(directory)
                (root / "manifests" / "problems" / "alpha.toml").write_text(
                    textwrap.dedent(
                        f'''\
                        id = "alpha"
                        title = "Alpha"
                        {module_line}group = "formalization-evaluation"
                        status = "draft"
                        visible = true
                        statement_revision = 1
                        tags = []
                        '''
                    ),
                    encoding="utf-8",
                )
                with self.assertRaisesRegex(INVENTORY.InventoryError, "module must"):
                    INVENTORY.load_inventory(root)

    def test_unexpected_directory_entry_fails_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = self._root(directory)
            (root / "manifests" / "problems" / "README.txt").write_text(
                "ignored?", encoding="utf-8"
            )
            with self.assertRaisesRegex(INVENTORY.InventoryError, "only regular TOML"):
                INVENTORY.load_inventory(root)

    def test_output_pair_is_distinct_exclusive_and_complete(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            json_path = root / "report.json"
            markdown_path = root / "report.md"
            with self.assertRaisesRegex(INVENTORY.InventoryError, "distinct"):
                INVENTORY.write_outputs(json_path, b"{}\n", json_path, b"# Report\n")

            json_path.write_text("existing", encoding="utf-8")
            with self.assertRaisesRegex(INVENTORY.InventoryError, "refusing to overwrite"):
                INVENTORY.write_outputs(
                    json_path, b"{}\n", markdown_path, b"# Report\n"
                )
            self.assertFalse(markdown_path.exists())

            json_path.unlink()
            INVENTORY.write_outputs(json_path, b"{}\n", markdown_path, b"# Report\n")
            self.assertEqual(json.loads(json_path.read_text(encoding="utf-8")), {})
            self.assertEqual(markdown_path.read_text(encoding="utf-8"), "# Report\n")

    def test_second_output_failure_rolls_back_first_and_temporary_files(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            json_path = root / "rollback.json"
            markdown_path = root / "rollback.md"
            real_link = INVENTORY.os.link

            def fail_second_link(source: object, destination: object) -> None:
                if pathlib.Path(destination) == markdown_path:
                    raise OSError("synthetic second-link failure")
                real_link(source, destination)

            with mock.patch.object(INVENTORY.os, "link", side_effect=fail_second_link):
                with self.assertRaisesRegex(INVENTORY.InventoryError, "complete output pair"):
                    INVENTORY.write_outputs(
                        json_path, b"{}\n", markdown_path, b"# Report\n"
                    )
            self.assertEqual(list(root.iterdir()), [])


if __name__ == "__main__":
    unittest.main()
