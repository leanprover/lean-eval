"""Small stdlib-only workspaces exercising the trusted production test driver."""

from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[2]


def require_tools(required: bool) -> bool:
    tools = ["lake", os.environ.get("COMPARATOR_BWRAP", "bwrap")]
    missing = [tool for tool in tools if shutil.which(tool) is None]
    if missing:
        if required:
            raise RuntimeError(f"Missing tools: {', '.join(missing)}")
        print(f"SKIP: missing tools: {', '.join(missing)}")
    return not missing


def workspace(
    directory: Path,
    submission: str = "namespace Submission\ntheorem target : True := True.intro\nend Submission\n",
    *,
    challenge: str = "theorem target : True := True.intro\n",
    solution: str = "import Submission\ntheorem target : True := Submission.target\n",
    definitions: tuple[str, ...] = (),
) -> Path:
    directory.mkdir(parents=True)
    files = {
        "lean-toolchain": (ROOT / "lean-toolchain").read_text(),
        "lakefile.toml": 'name = "comparator_probe"\ntestDriver = "workspace_test"\n'
        '[[lean_lib]]\nname = "Challenge"\n[[lean_lib]]\nname = "Submission"\n'
        '[[lean_lib]]\nname = "Solution"\n[[lean_exe]]\nname = "workspace_test"\nroot = "WorkspaceTest"\n',
        "lake-manifest.json": json.dumps({
            "version": "1.3.0", "packagesDir": ".lake/packages", "packages": [],
            "name": "comparator_probe", "lakeDir": ".lake",
        }),
        "Challenge.lean": challenge,
        "Submission.lean": submission,
        "Solution.lean": solution,
        "WorkspaceTest.lean": (ROOT / "templates/WorkspaceTest.lean").read_text(),
        # Deliberately disabled here: the trusted harness must enforce NanoDa.
        "config.json": json.dumps({
            "challenge_module": "Challenge", "solution_module": "Solution",
            "theorem_names": ["target"], "definition_names": list(definitions),
            "permitted_axioms": ["propext", "Quot.sound", "Classical.choice"],
            "enable_nanoda": False, "external_kernels": {},
        }),
    }
    for name, contents in files.items():
        (directory / name).write_text(contents)
    return directory


def compare(directory: Path, *, env: dict[str, str] | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["lake", "test"], cwd=directory, env={**os.environ, **(env or {})},
        capture_output=True, text=True, timeout=300,
    )


def assert_exit(result: subprocess.CompletedProcess[str], expected: int = 0) -> None:
    if result.returncode != expected:
        raise AssertionError(
            f"Expected exit {expected}, got {result.returncode}\n{result.stdout}{result.stderr}"
        )
