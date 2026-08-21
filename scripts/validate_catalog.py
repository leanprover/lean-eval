#!/usr/bin/env python3
"""Validate LeanEval catalog metadata and immutable named sets."""

from __future__ import annotations

import argparse
import datetime as dt
import pathlib
import re
import subprocess
import tomllib
from collections.abc import Mapping, Sequence


PROBLEM_ID_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_-]*$")
TAG_RE = re.compile(r"^[a-z0-9][a-z0-9-]*$")
DIGEST_RE = re.compile(r"^sha256:[0-9a-f]{64}$")
GROUPS = {"formalization-evaluation", "software-verification", "open-conjectures"}
STATUSES = {"draft", "active", "archived"}
REASONS = {
    "initial",
    "statement-change",
    "policy",
    "correction",
    "retraction",
    "restoration",
}


class CatalogError(ValueError):
    """A catalog invariant was violated."""


def _table(value: object, label: str) -> Mapping[str, object]:
    if not isinstance(value, dict):
        raise CatalogError(f"{label} must be a TOML table")
    return value


def _string(value: object, label: str) -> str:
    if not isinstance(value, str) or not value:
        raise CatalogError(f"{label} must be a non-empty string")
    return value


def _integer(value: object, label: str) -> int:
    if type(value) is not int or value <= 0:
        raise CatalogError(f"{label} must be a positive integer")
    return value


def _date(value: object, label: str) -> str:
    text = _string(value, label)
    try:
        parsed = dt.date.fromisoformat(text)
    except ValueError as error:
        raise CatalogError(f"{label} must be an ISO 8601 calendar date: {error}") from error
    if parsed.isoformat() != text:
        raise CatalogError(f"{label} must use canonical YYYY-MM-DD form")
    return text


def _array(value: object, label: str) -> Sequence[object]:
    if not isinstance(value, list):
        raise CatalogError(f"{label} must be an array")
    return value


def load_tag_registry(root: pathlib.Path) -> dict[str, Mapping[str, object]]:
    path = root / "manifests" / "tags.toml"
    try:
        data = tomllib.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, tomllib.TOMLDecodeError) as error:
        raise CatalogError(f"cannot read tag registry {path}: {error}") from error
    if data.get("schema_version") != 1:
        raise CatalogError(f"{path}: schema_version must be 1")
    tags = _table(data.get("tags"), f"{path}: tags")
    out: dict[str, Mapping[str, object]] = {}
    for name, raw in sorted(tags.items()):
        if TAG_RE.fullmatch(name) is None:
            raise CatalogError(f"{path}: invalid tag name {name!r}")
        entry = _table(raw, f"{path}: tags.{name}")
        _string(entry.get("label"), f"{path}: tags.{name}.label")
        _string(entry.get("description"), f"{path}: tags.{name}.description")
        out[name] = entry
    return out


def _validate_status_history(path: pathlib.Path, problem: Mapping[str, object]) -> None:
    rows = _array(problem.get("status_history", []), f"{path}: status_history")
    previous_date = ""
    statuses: list[str] = []
    for index, raw in enumerate(rows):
        label = f"{path}: status_history[{index}]"
        row = _table(raw, label)
        status = _string(row.get("status"), f"{label}.status")
        if status not in STATUSES:
            raise CatalogError(f"{label}.status has unknown value {status!r}")
        effective_date = _date(row.get("effective_date"), f"{label}.effective_date")
        reason = _string(row.get("reason"), f"{label}.reason")
        if reason not in REASONS:
            raise CatalogError(f"{label}.reason has unknown category {reason!r}")
        if effective_date <= previous_date:
            raise CatalogError(f"{path}: status_history dates must increase strictly")
        previous_date = effective_date
        statuses.append(status)
    if statuses and statuses[-1] != problem["status"]:
        raise CatalogError(f"{path}: final status_history entry must equal current status")


def _validate_revision_history(path: pathlib.Path, problem: Mapping[str, object]) -> set[int]:
    rows = _array(problem.get("revision_history", []), f"{path}: revision_history")
    previous_date = ""
    previous_revision = 0
    revisions: set[int] = {int(problem["statement_revision"])}
    for index, raw in enumerate(rows):
        label = f"{path}: revision_history[{index}]"
        row = _table(raw, label)
        revision = _integer(row.get("revision"), f"{label}.revision")
        effective_date = _date(row.get("effective_date"), f"{label}.effective_date")
        reason = _string(row.get("reason"), f"{label}.reason")
        digest = _string(row.get("statement_digest"), f"{label}.statement_digest")
        if reason not in REASONS:
            raise CatalogError(f"{label}.reason has unknown category {reason!r}")
        if DIGEST_RE.fullmatch(digest) is None:
            raise CatalogError(f"{label}.statement_digest must be sha256:<64 lowercase hex digits>")
        if revision <= previous_revision or effective_date <= previous_date:
            raise CatalogError(f"{path}: revision_history revisions and dates must increase strictly")
        previous_revision = revision
        previous_date = effective_date
        revisions.add(revision)
    if rows and previous_revision != problem["statement_revision"]:
        raise CatalogError(f"{path}: final revision_history entry must equal statement_revision")
    return revisions


def load_problems(
    root: pathlib.Path, registry: Mapping[str, object]
) -> tuple[dict[str, Mapping[str, object]], dict[str, set[int]]]:
    directory = root / "manifests" / "problems"
    problems: dict[str, Mapping[str, object]] = {}
    revisions: dict[str, set[int]] = {}
    for path in sorted(directory.glob("*.toml")):
        try:
            problem = tomllib.loads(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, tomllib.TOMLDecodeError) as error:
            raise CatalogError(f"cannot read problem manifest {path}: {error}") from error
        problem_id = _string(problem.get("id"), f"{path}: id")
        if problem_id != path.stem or PROBLEM_ID_RE.fullmatch(problem_id) is None:
            raise CatalogError(f"{path}: id must be safe and match the filename")
        if problem_id in problems:
            raise CatalogError(f"duplicate problem id {problem_id!r}")
        _string(problem.get("title"), f"{path}: title")
        group = _string(problem.get("group"), f"{path}: group")
        status = _string(problem.get("status"), f"{path}: status")
        if group not in GROUPS:
            raise CatalogError(f"{path}: unknown group {group!r}")
        if status not in STATUSES:
            raise CatalogError(f"{path}: unknown status {status!r}")
        if type(problem.get("visible")) is not bool:
            raise CatalogError(f"{path}: visible must be a boolean")
        _integer(problem.get("statement_revision"), f"{path}: statement_revision")
        raw_tags = _array(problem.get("tags"), f"{path}: tags")
        if not all(isinstance(tag, str) for tag in raw_tags):
            raise CatalogError(f"{path}: every tag must be a string")
        tags = list(raw_tags)
        if len(tags) != len(set(tags)):
            raise CatalogError(f"{path}: tags must not contain duplicates")
        unknown = sorted(set(tags) - registry.keys())
        if unknown:
            raise CatalogError(f"{path}: unregistered tags: {', '.join(unknown)}")
        _validate_status_history(path, problem)
        revisions[problem_id] = _validate_revision_history(path, problem)
        problems[problem_id] = problem
    return problems, revisions


def load_sets(
    root: pathlib.Path,
    problems: Mapping[str, Mapping[str, object]],
    revisions: Mapping[str, set[int]],
) -> dict[str, Mapping[str, object]]:
    directory = root / "manifests" / "sets"
    sets: dict[str, Mapping[str, object]] = {}
    if not directory.is_dir():
        raise CatalogError(f"named-set directory does not exist: {directory}")
    for path in sorted(directory.glob("*.toml")):
        try:
            named_set = tomllib.loads(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, tomllib.TOMLDecodeError) as error:
            raise CatalogError(f"cannot read named set {path}: {error}") from error
        if named_set.get("schema_version") != 1:
            raise CatalogError(f"{path}: schema_version must be 1")
        set_id = _string(named_set.get("id"), f"{path}: id")
        if set_id != path.stem or TAG_RE.fullmatch(set_id) is None:
            raise CatalogError(f"{path}: id must be lowercase kebab-case and match the filename")
        _string(named_set.get("title"), f"{path}: title")
        if type(named_set.get("frozen")) is not bool:
            raise CatalogError(f"{path}: frozen must be a boolean")
        if "published_at" in named_set:
            _date(named_set["published_at"], f"{path}: published_at")
        if named_set["frozen"] and "published_at" not in named_set:
            raise CatalogError(f"{path}: a frozen set requires published_at")
        members = _array(named_set.get("members"), f"{path}: members")
        seen: set[tuple[str, int]] = set()
        for index, raw in enumerate(members):
            label = f"{path}: members[{index}]"
            member = _table(raw, label)
            problem_id = _string(member.get("problem_id"), f"{label}.problem_id")
            revision = _integer(member.get("statement_revision"), f"{label}.statement_revision")
            if problem_id not in problems:
                raise CatalogError(f"{label}: unknown problem {problem_id!r}")
            if revision not in revisions[problem_id]:
                raise CatalogError(f"{label}: unknown statement revision {revision} for {problem_id}")
            key = (problem_id, revision)
            if key in seen:
                raise CatalogError(f"{path}: duplicate member {problem_id}@{revision}")
            seen.add(key)
        sets[set_id] = named_set
    return sets


def _git(root: pathlib.Path, *args: str) -> str:
    completed = subprocess.run(
        ["git", *args], cwd=root, check=True, text=True, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    return completed.stdout


def compare_with_base(
    root: pathlib.Path,
    base_ref: str,
    problems: Mapping[str, Mapping[str, object]],
    sets: Mapping[str, Mapping[str, object]],
) -> None:
    """Enforce lifecycle monotonicity and membership of already-frozen sets."""
    problem_paths = _git(root, "ls-tree", "-r", "--name-only", base_ref, "--", "manifests/problems")
    for relative in sorted(path for path in problem_paths.splitlines() if path.endswith(".toml")):
        raw = tomllib.loads(_git(root, "show", f"{base_ref}:{relative}"))
        problem_id = raw.get("id")
        current = problems.get(problem_id) if isinstance(problem_id, str) else None
        if current is None or "statement_revision" not in raw:
            continue
        old_revision = raw["statement_revision"]
        new_revision = current["statement_revision"]
        for history_field in ("status_history", "revision_history"):
            old_history = raw.get(history_field, [])
            new_history = current.get(history_field, [])
            if new_history[:len(old_history)] != old_history:
                raise CatalogError(f"{relative}: {history_field} is append-only")
        if type(old_revision) is int and type(new_revision) is int and new_revision < old_revision:
            raise CatalogError(f"{relative}: statement_revision may not decrease")
        if type(old_revision) is int and new_revision > old_revision:
            history = current.get("revision_history", [])
            if not history or history[-1].get("revision") != new_revision:
                raise CatalogError(f"{relative}: a revision increase requires a final revision_history entry")
        if "status" in raw and raw["status"] != current.get("status"):
            history = current.get("status_history", [])
            if not history or history[-1].get("status") != current.get("status"):
                raise CatalogError(f"{relative}: a status change requires a final status_history entry")

    set_paths = _git(root, "ls-tree", "-r", "--name-only", base_ref, "--", "manifests/sets")
    for relative in sorted(path for path in set_paths.splitlines() if path.endswith(".toml")):
        old = tomllib.loads(_git(root, "show", f"{base_ref}:{relative}"))
        if old.get("frozen") is not True:
            continue
        set_id = old.get("id")
        current = sets.get(set_id) if isinstance(set_id, str) else None
        if current is None:
            raise CatalogError(f"{relative}: a frozen set may not be deleted")
        if current.get("frozen") is not True:
            raise CatalogError(f"{relative}: a frozen set may not be unfrozen")
        old_members = {
            (member.get("problem_id"), member.get("statement_revision"))
            for member in old.get("members", [])
        }
        new_members = {
            (member.get("problem_id"), member.get("statement_revision"))
            for member in current.get("members", [])
        }
        if old_members != new_members:
            raise CatalogError(f"{relative}: membership of a frozen set may not change")


def validate(root: pathlib.Path, base_ref: str | None = None) -> tuple[int, int, int]:
    registry = load_tag_registry(root)
    problems, revisions = load_problems(root, registry)
    sets = load_sets(root, problems, revisions)
    if base_ref is not None:
        compare_with_base(root, base_ref, problems, sets)
    return len(problems), len(registry), len(sets)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=pathlib.Path, default=pathlib.Path("."))
    parser.add_argument("--base-ref", help="Git ref used to enforce immutable frozen sets")
    args = parser.parse_args()
    try:
        problem_count, tag_count, set_count = validate(args.root.resolve(), args.base_ref)
    except (CatalogError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"catalog validation failed: {error}\n")
    print(f"Catalog valid: {problem_count} problems, {tag_count} tags, {set_count} named sets.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
