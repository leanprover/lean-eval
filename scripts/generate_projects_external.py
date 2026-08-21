#!/usr/bin/env python3
"""Generate or check one workspace through the extracted JSON CLI.

The embedded Lean implementation remains authoritative until corpus-wide
parity has been demonstrated. This adapter is the first consumer seam.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GENERATOR_ROOT = ROOT.parent / "lean-eval-generator"
GENERATOR = GENERATOR_ROOT / ".lake/build/bin/lean-eval-generator"
IGNORED = {".lake", "build", ".cache", "lake-manifest.json"}


def run(command: list[str], *, cwd: Path, stdin: str | None = None) -> str:
    result = subprocess.run(
        command,
        cwd=cwd,
        input=stdin,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode != 0:
        details = "\n".join(part for part in (result.stderr, result.stdout) if part)
        raise RuntimeError(f"command failed: {' '.join(command)}\n{details}")
    return result.stdout


def module_path(module: str) -> Path:
    return ROOT.joinpath(*module.split(".")).with_suffix(".lean")


def request_for(problem_id: str) -> dict[str, object]:
    manifest_path = ROOT / f"manifests/problems/{problem_id}.toml"
    if not manifest_path.is_file():
        raise RuntimeError(f"unknown problem id: {problem_id}")
    manifest = tomllib.loads(manifest_path.read_text(encoding="utf-8"))
    module = str(manifest["module"])
    run(["lake", "build", module, "extract_theorem"], cwd=ROOT)
    extractor = ROOT / ".lake/build/bin/extract_theorem"
    resolved = []
    for hole in manifest["holes"]:
        extracted = json.loads(
            run(["lake", "env", str(extractor), module, str(hole)], cwd=ROOT)
        )
        source_range = extracted.pop("sourceRange")
        resolved.append({**extracted, **source_range})

    lakefile = tomllib.loads((ROOT / "lakefile.toml").read_text(encoding="utf-8"))
    mathlib = [item for item in lakefile["require"] if item["name"] == "mathlib"]
    if len(mathlib) != 1:
        raise RuntimeError("expected exactly one Mathlib dependency")
    problem = {
        "id": manifest["id"],
        "title": manifest["title"],
        "group": manifest["group"],
        "status": manifest["status"],
        "visible": manifest["visible"],
        "statementRevision": manifest["statement_revision"],
        "tags": manifest["tags"],
        "moduleName": module,
        "holes": manifest["holes"],
        "submitter": manifest["submitter"],
        "notes": manifest.get("notes"),
        "source": manifest.get("source"),
        "informalSolution": manifest.get("informal_solution"),
        "moduleContent": module_path(module).read_text(encoding="utf-8"),
        "resolvedHoles": resolved,
    }
    return {
        "schemaVersion": 1,
        "contextRoot": str(ROOT),
        "leanToolchain": (ROOT / "lean-toolchain").read_text(encoding="utf-8"),
        "mathlib": mathlib[0],
        "templates": {
            "workspaceTest": (ROOT / "templates/WorkspaceTest.lean").read_text(
                encoding="utf-8"
            )
        },
        "problems": [problem],
    }


def current_files(workspace: Path) -> set[str]:
    return {
        path.relative_to(workspace).as_posix()
        for path in workspace.rglob("*")
        if path.is_file() and not IGNORED.intersection(path.relative_to(workspace).parts)
    }


def apply_response(problem_id: str, response: dict[str, object], check: bool) -> None:
    if response.get("schemaVersion") != 1:
        raise RuntimeError("generator returned an unsupported response version")
    workspace = ROOT / "generated" / problem_id
    files = {
        item["path"]: item["content"]
        for item in response["files"]
        if item["problemId"] == problem_id
    }
    expected_paths = set(files)
    if check:
        mismatches = []
        for path, content in files.items():
            target = workspace / path
            if not target.is_file() or target.read_text(encoding="utf-8") != content:
                mismatches.append(f"generated/{problem_id}/{path} differs")
        for extra in sorted(current_files(workspace) - expected_paths):
            mismatches.append(f"generated/{problem_id}/{extra} is unexpected")
        if mismatches:
            raise RuntimeError("\n".join(mismatches))
        print(f"Generated workspace {problem_id} is up to date.")
        return
    for path, content in files.items():
        target = workspace / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(content, encoding="utf-8")
    for extra in current_files(workspace) - expected_paths:
        raise RuntimeError(
            f"refusing to delete unexpected path generated/{problem_id}/{extra}; remove it manually"
        )
    print(f"Generated workspace {problem_id} through the extracted generator.")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--problem", required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    try:
        run(["lake", "build"], cwd=GENERATOR_ROOT)
        response = json.loads(
            run(
                [str(GENERATOR)],
                cwd=ROOT,
                stdin=json.dumps(request_for(args.problem), separators=(",", ":")),
            )
        )
        apply_response(args.problem, response, args.check)
        return 0
    except (RuntimeError, OSError, json.JSONDecodeError) as error:
        print(f"external generator: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
