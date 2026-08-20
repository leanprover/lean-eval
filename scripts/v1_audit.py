#!/usr/bin/env python3
"""Produce deterministic solve-count evidence for a proposed LeanEval v1 set."""

from __future__ import annotations

import argparse
import json
import pathlib
import tomllib
from collections import defaultdict
from collections.abc import Iterable, Mapping
from typing import Any


class AuditError(ValueError):
    """The input result store is malformed."""


def load_catalog(root: pathlib.Path) -> dict[str, Mapping[str, Any]]:
    catalog: dict[str, Mapping[str, Any]] = {}
    for path in sorted((root / "manifests" / "problems").glob("*.toml")):
        try:
            data = tomllib.loads(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, tomllib.TOMLDecodeError) as error:
            raise AuditError(f"cannot read {path}: {error}") from error
        problem_id = data.get("id")
        if not isinstance(problem_id, str) or problem_id in catalog:
            raise AuditError(f"{path}: missing or duplicate problem id")
        catalog[problem_id] = data
    return catalog


def _v1_records(data: Mapping[str, Any], path: pathlib.Path) -> Iterable[dict[str, Any]]:
    user = data.get("user")
    solved = data.get("solved")
    if not isinstance(user, str) or not isinstance(solved, dict):
        raise AuditError(f"{path}: v1 file requires string user and solved object")
    for model in sorted(solved):
        problems = solved[model]
        if not isinstance(model, str) or not isinstance(problems, dict):
            raise AuditError(f"{path}: malformed v1 model entry")
        for problem_id in sorted(problems):
            record = problems[problem_id]
            if not isinstance(problem_id, str) or not isinstance(record, dict):
                raise AuditError(f"{path}: malformed v1 result entry")
            yield {
                "user": user,
                "declared_model": model,
                "problem_id": problem_id,
                "accepted_at": record.get("solved_at"),
                "issue_number": record.get("issue_number"),
                "submission_public": record.get("submission_public"),
            }


def _v2_records(data: Mapping[str, Any], path: pathlib.Path) -> Iterable[dict[str, Any]]:
    file_user = data.get("user")
    records = data.get("results")
    if not isinstance(records, list):
        raise AuditError(f"{path}: v2 file requires results array")
    for index, record in enumerate(records):
        if not isinstance(record, dict):
            raise AuditError(f"{path}: results[{index}] must be an object")
        submission = record.get("submission", {})
        intake = record.get("intake", {})
        yield {
            "user": record.get("user", file_user),
            "declared_model": record.get("declared_model"),
            "problem_id": record.get("problem_id"),
            "accepted_at": record.get("accepted_at"),
            "issue_number": intake.get("issue_number") if isinstance(intake, dict) else None,
            "submission_public": submission.get("public") if isinstance(submission, dict) else None,
        }


def load_records(results_dir: pathlib.Path) -> tuple[list[dict[str, Any]], int]:
    records: list[dict[str, Any]] = []
    files = sorted(results_dir.glob("*.json"))
    for path in files:
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, json.JSONDecodeError) as error:
            raise AuditError(f"cannot read {path}: {error}") from error
        if not isinstance(data, dict):
            raise AuditError(f"{path}: root must be an object")
        version = data.get("schema_version")
        if version == 1:
            loaded = _v1_records(data, path)
        elif version == 2:
            loaded = _v2_records(data, path)
        else:
            raise AuditError(f"{path}: unsupported schema_version {version!r}")
        for record in loaded:
            if not all(isinstance(record.get(key), str) and record[key] for key in
                       ("user", "declared_model", "problem_id")):
                raise AuditError(f"{path}: result identity fields must be non-empty strings")
            accepted_at = record.get("accepted_at")
            if accepted_at is not None and not isinstance(accepted_at, str):
                raise AuditError(f"{path}: acceptance timestamp must be a string or null")
            issue_number = record.get("issue_number")
            if issue_number is not None and type(issue_number) is not int:
                raise AuditError(f"{path}: issue_number must be an integer or null")
            records.append(record)
    return records, len(files)


def build_report(
    catalog: Mapping[str, Mapping[str, Any]], records: list[dict[str, Any]], file_count: int
) -> dict[str, Any]:
    by_problem: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        by_problem[record["problem_id"]].append(record)
    unknown = sorted(set(by_problem) - catalog.keys())
    rows: list[dict[str, Any]] = []
    for problem_id in sorted(set(catalog) | set(by_problem)):
        metadata = catalog.get(problem_id, {})
        solves = by_problem.get(problem_id, [])
        timestamps = sorted(
            record["accepted_at"] for record in solves if isinstance(record.get("accepted_at"), str)
        )
        issue_numbers = sorted({
            record["issue_number"] for record in solves if type(record.get("issue_number")) is int
        })
        rows.append({
            "problem_id": problem_id,
            "catalog_present": problem_id in catalog,
            "title": metadata.get("title", problem_id),
            "group": metadata.get("group"),
            "status": metadata.get("status"),
            "visible": metadata.get("visible"),
            "statement_revision": metadata.get("statement_revision"),
            "tags": metadata.get("tags", []),
            "solve_count": len(solves),
            "unique_model_count": len({record["declared_model"] for record in solves}),
            "unique_user_count": len({record["user"] for record in solves}),
            "public_submission_count": sum(record.get("submission_public") is True for record in solves),
            "first_accepted_at": timestamps[0] if timestamps else None,
            "last_accepted_at": timestamps[-1] if timestamps else None,
            "issue_numbers": issue_numbers,
        })
    return {
        "schema_version": 1,
        "catalog_problem_count": len(catalog),
        "result_file_count": file_count,
        "result_record_count": len(records),
        "unknown_problem_ids": unknown,
        "problems": rows,
    }


def render_markdown(report: Mapping[str, Any]) -> str:
    def cell(value: object) -> str:
        if value is None:
            return "—"
        return str(value).replace("|", "\\|").replace("\n", " ")

    lines = [
        "# LeanEval v1 solve-count evidence",
        "",
        f"- Catalog problems: {report['catalog_problem_count']}",
        f"- Result files: {report['result_file_count']}",
        f"- Result records: {report['result_record_count']}",
        f"- Unknown problem IDs: {len(report['unknown_problem_ids'])}",
        "",
        "This report is evidence only; it does not recommend or choose v1 membership.",
        "",
        "| Problem | Status | Visible | Solves | Models | Users | First accepted |",
        "|---|---|---:|---:|---:|---:|---|",
    ]
    for row in report["problems"]:
        lines.append(
            f"| `{cell(row['problem_id'])}` | {cell(row['status'])} | "
            f"{cell(row['visible'])} | {row['solve_count']} | {row['unique_model_count']} | "
            f"{row['unique_user_count']} | {cell(row['first_accepted_at'])} |"
        )
    return "\n".join(lines) + "\n"


def write_outputs(report: Mapping[str, Any], json_output: pathlib.Path, markdown_output: pathlib.Path) -> None:
    json_output.write_text(
        json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n", encoding="utf-8"
    )
    markdown_output.write_text(render_markdown(report), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=pathlib.Path, default=pathlib.Path("."))
    parser.add_argument("--results-dir", type=pathlib.Path, required=True)
    parser.add_argument("--json-output", type=pathlib.Path, required=True)
    parser.add_argument("--markdown-output", type=pathlib.Path, required=True)
    args = parser.parse_args()
    try:
        catalog = load_catalog(args.root.resolve())
        records, file_count = load_records(args.results_dir.resolve())
        report = build_report(catalog, records, file_count)
        write_outputs(report, args.json_output, args.markdown_output)
    except AuditError as error:
        parser.exit(1, f"v1 audit failed: {error}\n")
    print(
        f"Wrote evidence for {report['catalog_problem_count']} catalog problems and "
        f"{report['result_record_count']} result records."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
