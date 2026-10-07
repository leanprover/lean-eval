"""Offline tests for scripts/check_pipeline_toolchain_contract.py over a file:// tree."""
from __future__ import annotations

import importlib.util
import json
import pathlib
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location(
    "check_pipeline_toolchain_contract",
    ROOT / "scripts" / "check_pipeline_toolchain_contract.py",
)
contract = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(contract)

RC_PATTERN = "^leanprover/lean4:v[0-9]+\\.[0-9]+\\.[0-9]+(?:-(?:rc|beta)[0-9]+)?$"
RELEASE_PATTERN = "^leanprover/lean4:v[0-9]+\\.[0-9]+\\.[0-9]+$"


class PipelineToolchainContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = pathlib.Path(self.temporary.name)
        self.base_url = self.root.as_uri()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def _write(self, repository: str, path: str, document: object) -> None:
        target = self.root / repository / "main" / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(json.dumps(document), encoding="utf-8")

    def _tree(self, pattern: str) -> None:
        for repository, path in contract.CONTRACTS:
            self._write(repository, path, {
                "properties": {"toolchain": {"type": "string", "pattern": pattern}},
                "$defs": {"nested": {"items": [{"pattern": pattern}]}},
            })
        self._write(*contract.VECTORS, {
            "schema_version": 1,
            "accepted": ["leanprover/lean4:v4.35.0-rc3"],
            "rejected": ["leanprover/lean4:v4.35.0-nightly"],
        })

    def test_release_candidate_pin_passes_widened_contracts(self) -> None:
        self._tree(RC_PATTERN)
        self.assertEqual(contract.check("leanprover/lean4:v4.35.0-rc3", self.base_url), [])

    def test_release_only_contract_names_every_rejecting_pattern(self) -> None:
        self._tree(RELEASE_PATTERN)
        violations = contract.check("leanprover/lean4:v4.35.0-rc3", self.base_url)
        self.assertEqual(len(violations), 2 * len(contract.CONTRACTS))
        self.assertTrue(all("rejects 'leanprover/lean4:v4.35.0-rc3'" in v for v in violations))

    def test_vector_rejection_is_reported_even_when_patterns_pass(self) -> None:
        self._tree("^leanprover/lean4:v.*$")
        violations = contract.check("leanprover/lean4:v4.35.0-nightly", self.base_url)
        self.assertEqual(len(violations), 1)
        self.assertIn("lists 'leanprover/lean4:v4.35.0-nightly' as rejected", violations[0])

    def test_contract_without_patterns_is_an_error_not_a_pass(self) -> None:
        self._tree(RC_PATTERN)
        self._write(*contract.CONTRACTS[0], {"properties": {}})
        with self.assertRaisesRegex(contract.ContractError, "no toolchain pattern"):
            contract.check("leanprover/lean4:v4.35.0-rc3", self.base_url)

    def test_main_reads_the_repository_pin(self) -> None:
        self._tree(RC_PATTERN)
        pin = self.root / "lean-toolchain"
        pin.write_text("leanprover/lean4:v4.35.0-rc3\n", encoding="utf-8")
        self.assertEqual(
            contract.main(["--toolchain-file", str(pin), "--base-url", self.base_url]), 0,
        )
        pin.write_text("leanprover/lean4:v4.35\n", encoding="utf-8")
        self.assertEqual(
            contract.main(["--toolchain-file", str(pin), "--base-url", self.base_url]), 1,
        )


if __name__ == "__main__":
    unittest.main()
