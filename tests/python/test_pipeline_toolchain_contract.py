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
RC3 = "leanprover/lean4:v4.35.0-rc3"


def nest(pointer: tuple[str, ...], value: object) -> dict:
    document: object = value
    for key in reversed(pointer):
        document = {key: document}
    assert isinstance(document, dict)
    return document


class PipelineToolchainContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = pathlib.Path(self.temporary.name)
        self.base_url = self.root.as_uri()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def _write(self, path: str, document: object) -> None:
        target = self.root / contract.PIPELINE / "main" / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(json.dumps(document), encoding="utf-8")

    def _tree(self, pattern: str, *, accepted=(RC3,), rejected=("leanprover/lean4:v4.35.0-nightly",)) -> None:
        for path, pointer in contract.CONTRACTS:
            self._write(path, nest(pointer, pattern))
        self._write(contract.VECTORS, {
            "schema_version": 1, "accepted": list(accepted), "rejected": list(rejected),
        })

    def test_release_candidate_pin_passes_widened_contracts(self) -> None:
        self._tree(RC_PATTERN)
        self.assertEqual(contract.check(RC3, self.base_url), [])

    def test_release_only_contract_names_every_rejecting_schema(self) -> None:
        self._tree(RELEASE_PATTERN)
        violations = contract.check(RC3, self.base_url)
        rejects_pin = [v for v in violations if f"rejects {RC3!r}" in v]
        self.assertEqual(len(rejects_pin), len(contract.CONTRACTS))
        # The accepted vector is an rc too, so the drifted schema is reported on its own.
        self.assertTrue(any("rejects the shared accepted vector" in v for v in violations))

    def test_schema_that_accepts_a_rejected_vector_is_reported(self) -> None:
        self._tree("^leanprover/lean4:v.*$")
        violations = contract.check(RC3, self.base_url)
        self.assertEqual(len(violations), len(contract.CONTRACTS))
        self.assertTrue(all("accepts the shared rejected vector" in v for v in violations))

    def test_pin_listed_as_rejected_vector_fails(self) -> None:
        self._tree(RC_PATTERN, rejected=(RC3,))
        violations = contract.check(RC3, self.base_url)
        self.assertTrue(any("lists 'leanprover/lean4:v4.35.0-rc3' as rejected" in v for v in violations))

    def test_unsupported_contract_shapes_fail_closed(self) -> None:
        self._tree(RC_PATTERN)
        path, pointer = contract.CONTRACTS[0]
        self._write(path, {"properties": {}})
        with self.assertRaisesRegex(contract.ContractError, "unsupported contract shape"):
            contract.check(RC3, self.base_url)
        self._write(path, nest(pointer, "leanprover/lean4:v"))  # unanchored
        with self.assertRaisesRegex(contract.ContractError, "not an anchored"):
            contract.check(RC3, self.base_url)
        self._tree(RC_PATTERN)
        self._write(contract.VECTORS, {"schema_version": 1, "accepted": [], "rejected": ["x"]})
        with self.assertRaisesRegex(contract.ContractError, "non-empty list"):
            contract.check(RC3, self.base_url)

    def test_pin_is_read_like_the_pipeline_reads_it(self) -> None:
        self._tree(RC_PATTERN)
        pin = self.root / "lean-toolchain"
        pin.write_text(RC3 + "\n", encoding="utf-8")
        self.assertEqual(contract.main(["--toolchain-file", str(pin), "--base-url", self.base_url]), 0)
        pin.write_text(RC3 + " \n", encoding="utf-8")  # a trailing space survives $(cat ...)
        self.assertEqual(contract.main(["--toolchain-file", str(pin), "--base-url", self.base_url]), 1)
        pin.write_text("leanprover/lean4:v4.35\n", encoding="utf-8")
        self.assertEqual(contract.main(["--toolchain-file", str(pin), "--base-url", self.base_url]), 1)
        pin.write_text("\n", encoding="utf-8")
        self.assertEqual(contract.main(["--toolchain-file", str(pin), "--base-url", self.base_url]), 1)


if __name__ == "__main__":
    unittest.main()
