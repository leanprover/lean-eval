#!/usr/bin/env python3
"""Exercise the actual generated workspace and an external immutable Mathlib cache."""
from pathlib import Path
import json
import re
import shutil
import sys

import probe


def main() -> None:
    scratch = Path(sys.argv[1])
    scratch.mkdir(parents=True, exist_ok=True)
    shared = scratch / "shared"
    shared.mkdir(exist_ok=True)
    (shared / "lean-toolchain").write_text(probe.TOOLCHAIN + "\n")
    (shared / "lakefile.toml").write_text(
        'name = "migration_cache"\n[[require]]\nname = "mathlib"\n'
        'git = "https://github.com/leanprover-community/mathlib4.git"\n'
        'rev = "5e0c4e5239cb0a2d86d68a884bf52cfd963fce22"\n')
    shutil.copyfile(probe.ROOT / "lake-manifest.json", shared / "lake-manifest.json")
    preparation = probe.run("remote-mathlib-cache-prepare", shared,
        [str(probe.LAKE), "exe", "cache", "get"], expected=0, timeout=900,
        env={"PATH": probe.trusted_path()})
    if preparation["exit_code"]:
        raise SystemExit("Mathlib cache preparation failed; see experiment log")
    workspace = scratch / "two_plus_two"
    shutil.copytree(probe.ROOT / "generated/two_plus_two", workspace)
    text = (workspace / "lakefile.toml").read_text()
    # The tested proof uses Mathlib only; avoid fetching the large solution-only
    # Lean Pool repository for this runner-capability experiment.
    text = re.sub(r'\[\[require\]\]\nname = "lean-pool"\n.*?(?=\[\[require\]\])',
                  '', text, count=1, flags=re.S)
    (workspace / "lakefile.toml").write_text(text)
    shutil.copyfile(shared / "lake-manifest.json", workspace / "lake-manifest.json")
    source = workspace / "Submission.lean"
    source.write_text(source.read_text().replace("  sorry", "  rfl"))
    settings = json.loads((workspace / "config.json").read_text())
    settings.pop("enable_nanoda", None)
    settings["external_kernels"] = {"nanoda": [str(probe.LEAN_BIN / "nanoda_bin")]}
    (workspace / "config.json").write_text(json.dumps(settings))
    (workspace / ".lake").mkdir()
    probe.CACHE = shared / ".lake/packages"
    (workspace / ".lake/packages").symlink_to(probe.CACHE)
    probe.compare("remote-generated-unmodified-cache-layout", workspace, expected=1,
                  env={"PATH": probe.trusted_path()})
    wrapper = probe.cache_wrapper(scratch)
    result = probe.compare("remote-generated-cache-readonly-bind", workspace,
        env={"COMPARATOR_BWRAP": str(wrapper), "PATH": probe.trusted_path()}, expected=0, timeout=600)
    if result["exit_code"]:
        raise SystemExit("Real generated comparator failed; see experiment log")
    (workspace / "WorkspaceTest.lean").write_text((probe.HERE / "PrototypeWorkspaceTest.lean").read_text())
    result = probe.run("remote-generated-lake-test", workspace, [str(probe.LAKE), "test"],
        env={"COMPARATOR_BWRAP": str(wrapper), "PATH": probe.trusted_path()}, expected=0, timeout=600)
    if result["exit_code"]:
        raise SystemExit("Generated lake test failed; see experiment log")


if __name__ == "__main__":
    main()
