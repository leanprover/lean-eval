#!/usr/bin/env python3
"""Validate LeanEval catalog metadata and append-only named sets."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import pathlib
import re
import subprocess
import tomllib
from collections.abc import Mapping, Sequence


PROBLEM_ID_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_-]*$")
TAG_RE = re.compile(r"^[a-z0-9][a-z0-9-]*$")
DIGEST_RE = re.compile(r"^sha256:[0-9a-f]{64}$")
GROUPS = {"formalization-evaluation", "software-verification", "open-problems"}
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
        schema_version = named_set.get("schema_version")
        if schema_version not in {1, 2}:
            raise CatalogError(f"{path}: schema_version must be 1 or 2")
        set_id = _string(named_set.get("id"), f"{path}: id")
        if set_id != path.stem or TAG_RE.fullmatch(set_id) is None:
            raise CatalogError(f"{path}: id must be lowercase kebab-case and match the filename")
        _string(named_set.get("title"), f"{path}: title")
        if type(named_set.get("frozen")) is not bool:
            raise CatalogError(f"{path}: frozen must be a boolean")
        published_at = ""
        if "published_at" in named_set:
            published_at = _date(named_set["published_at"], f"{path}: published_at")
        if named_set["frozen"] and "published_at" not in named_set:
            raise CatalogError(f"{path}: a frozen set requires published_at")
        members = _array(named_set.get("members"), f"{path}: members")
        seen: set[tuple[str, int]] = set()
        member_groups: set[str] = set()
        for index, raw in enumerate(members):
            label = f"{path}: members[{index}]"
            member = _table(raw, label)
            problem_id = _string(member.get("problem_id"), f"{label}.problem_id")
            revision = _integer(member.get("statement_revision"), f"{label}.statement_revision")
            if problem_id not in problems:
                raise CatalogError(f"{label}: unknown problem {problem_id!r}")
            if revision not in revisions[problem_id]:
                raise CatalogError(f"{label}: unknown statement revision {revision} for {problem_id}")
            member_groups.add(str(problems[problem_id]["group"]))
            key = (problem_id, revision)
            if key in seen:
                raise CatalogError(f"{path}: duplicate member {problem_id}@{revision}")
            seen.add(key)
        if len(member_groups) > 1:
            raise CatalogError(f"{path}: a named set may not span problem groups")

        amendments = _array(named_set.get("amendments", []), f"{path}: amendments")
        if schema_version == 1 and amendments:
            raise CatalogError(f"{path}: amendments require schema_version 2")
        if amendments and named_set["frozen"] is not True:
            raise CatalogError(f"{path}: only a frozen set may have amendments")
        amended_members: set[tuple[str, int]] = set()
        amendment_ids: set[str] = set()
        previous_date = published_at
        for amendment_index, raw_amendment in enumerate(amendments):
            label = f"{path}: amendments[{amendment_index}]"
            amendment = _table(raw_amendment, label)
            amendment_id = _string(amendment.get("id"), f"{label}.id")
            if TAG_RE.fullmatch(amendment_id) is None:
                raise CatalogError(f"{label}.id must be lowercase kebab-case")
            if amendment_id in amendment_ids:
                raise CatalogError(f"{path}: duplicate amendment id {amendment_id!r}")
            amendment_ids.add(amendment_id)
            effective_date = _date(
                amendment.get("effective_date"), f"{label}.effective_date"
            )
            if effective_date <= previous_date:
                raise CatalogError(
                    f"{path}: amendment dates must increase strictly after publication"
                )
            previous_date = effective_date
            _string(amendment.get("reason"), f"{label}.reason")
            _string(amendment.get("authorization"), f"{label}.authorization")
            if "evidence" in amendment:
                evidence = pathlib.PurePosixPath(
                    _string(amendment["evidence"], f"{label}.evidence")
                )
                if evidence.is_absolute() or ".." in evidence.parts:
                    raise CatalogError(f"{label}.evidence must be a safe repository path")
                if not (root / evidence).is_file():
                    raise CatalogError(f"{label}.evidence does not exist: {evidence}")
            additions = _array(amendment.get("additions"), f"{label}.additions")
            if not additions:
                raise CatalogError(f"{label}.additions must not be empty")
            for addition_index, raw_addition in enumerate(additions):
                addition_label = f"{label}.additions[{addition_index}]"
                addition = _table(raw_addition, addition_label)
                problem_id = _string(
                    addition.get("problem_id"), f"{addition_label}.problem_id"
                )
                revision = _integer(
                    addition.get("statement_revision"),
                    f"{addition_label}.statement_revision",
                )
                key = (problem_id, revision)
                if key not in seen:
                    raise CatalogError(
                        f"{addition_label}: addition is not an effective set member"
                    )
                if key in amended_members:
                    raise CatalogError(
                        f"{path}: member {problem_id}@{revision} is amended more than once"
                    )
                amended_members.add(key)

        if schema_version == 2:
            initial_member_count = _integer(
                named_set.get("initial_member_count"), f"{path}: initial_member_count"
            )
            if len(seen) != initial_member_count + len(amended_members):
                raise CatalogError(
                    f"{path}: effective membership must equal initial_member_count plus amendments"
                )
        sets[set_id] = named_set
    return sets


def _load_json_table(path: pathlib.Path) -> Mapping[str, object]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as error:
        raise CatalogError(f"cannot read canonical lifecycle evidence {path}: {error}") from error
    return _table(value, str(path))


def _history_contains(
    problem: Mapping[str, object], *, status: str, effective_date: str
) -> bool:
    return any(
        isinstance(row, dict)
        and row.get("status") == status
        and row.get("effective_date") == effective_date
        and row.get("reason") == "policy"
        for row in problem.get("status_history", [])
    )


def validate_v1_lifecycle_cutover(
    root: pathlib.Path,
    problems: Mapping[str, Mapping[str, object]],
    sets: Mapping[str, Mapping[str, object]],
) -> tuple[int, int, int] | None:
    """Validate the immutable v1 publication transitions against canonical evidence.

    Problems added after the selection and amendment evidence are intentionally
    unconstrained here, so they may enter the catalog as drafts. Later lifecycle
    changes to the pre-freeze problems remain possible because this check requires
    the publication event to stay in append-only history rather than requiring it
    to remain the current status forever.
    """

    selection_path = root / "audits" / "v1" / "selection-2026-08-20.json"
    amendment_path = root / "audits" / "v1" / "amendment-2026-08-21.json"
    if not selection_path.is_file() and not amendment_path.is_file():
        return None
    if not selection_path.is_file() or not amendment_path.is_file():
        raise CatalogError("canonical v1 lifecycle evidence is incomplete")

    selection = _load_json_table(selection_path)
    amendment = _load_json_table(amendment_path)
    v1 = sets.get("v1")
    if v1 is None:
        raise CatalogError("canonical v1 lifecycle evidence requires manifests/sets/v1.toml")
    publication_date = _date(v1.get("published_at"), "v1.published_at")

    effective_members = {
        (member.get("problem_id"), member.get("statement_revision"))
        for member in _array(v1.get("members"), "v1.members")
        if isinstance(member, dict)
    }
    all_amendment_additions = {
        (member.get("problem_id"), member.get("statement_revision"))
        for raw_amendment in _array(v1.get("amendments", []), "v1.amendments")
        if isinstance(raw_amendment, dict)
        for member in _array(raw_amendment.get("additions", []), "v1 amendment additions")
        if isinstance(member, dict)
    }
    initial_members = effective_members - all_amendment_additions
    expected_initial_count = _integer(v1.get("initial_member_count"), "v1.initial_member_count")
    if len(initial_members) != expected_initial_count:
        raise CatalogError("canonical v1 initial membership does not match initial_member_count")

    selection_rows = _array(selection.get("problems"), f"{selection_path}: problems")
    selection_problem_count = _integer(
        selection.get("catalog_problem_count"), f"{selection_path}: catalog_problem_count"
    )
    if len(selection_rows) != selection_problem_count:
        raise CatalogError(f"{selection_path}: catalog_problem_count does not match problems")
    selection_keys: set[tuple[str, int]] = set()
    archived_count = 0
    active_initial_count = 0
    for index, raw in enumerate(selection_rows):
        label = f"{selection_path}: problems[{index}]"
        row = _table(raw, label)
        problem_id = _string(row.get("problem_id"), f"{label}.problem_id")
        revision = _integer(row.get("statement_revision"), f"{label}.statement_revision")
        group = _string(row.get("group"), f"{label}.group")
        key = (problem_id, revision)
        if key in selection_keys:
            raise CatalogError(f"{label}: duplicate canonical selection problem revision")
        selection_keys.add(key)
        if group != "formalization-evaluation":
            continue
        problem = problems.get(problem_id)
        if problem is None:
            raise CatalogError(f"{label}: selected catalog problem is missing")
        expected_status = "active" if key in initial_members else "archived"
        if not _history_contains(
            problem, status=expected_status, effective_date=publication_date
        ):
            raise CatalogError(
                f"manifests/problems/{problem_id}.toml: missing canonical v1 "
                f"{expected_status} transition on {publication_date}"
            )
        if expected_status == "active":
            active_initial_count += 1
        else:
            archived_count += 1

    if not initial_members.issubset(selection_keys):
        raise CatalogError("canonical v1 initial membership is not contained in selection evidence")

    amendment_id = _string(
        amendment.get("amendment_id"), f"{amendment_path}: amendment_id"
    )
    amendment_date = _date(
        amendment.get("effective_date"), f"{amendment_path}: effective_date"
    )
    amendment_rows = _array(amendment.get("additions"), f"{amendment_path}: additions")
    amendment_entries: list[tuple[tuple[str, int], str]] = []
    amendment_keys: set[tuple[str, int]] = set()
    for index, raw in enumerate(amendment_rows):
        label = f"{amendment_path}: additions[{index}]"
        row = _table(raw, label)
        key = (
            _string(row.get("problem_id"), f"{label}.problem_id"),
            _integer(row.get("statement_revision"), f"{label}.statement_revision"),
        )
        if key in amendment_keys:
            raise CatalogError(f"{label}: duplicate canonical amendment problem revision")
        amendment_keys.add(key)
        amendment_entries.append((key, label))
    matching_set_amendments = [
        raw
        for raw in _array(v1.get("amendments", []), "v1.amendments")
        if isinstance(raw, dict) and raw.get("id") == amendment_id
    ]
    if len(matching_set_amendments) != 1:
        raise CatalogError(f"{amendment_path}: amendment_id does not identify one v1 amendment")
    set_amendment = matching_set_amendments[0]
    if set_amendment.get("effective_date") != amendment_date:
        raise CatalogError(f"{amendment_path}: effective_date does not match v1 amendment")
    set_amendment_keys = {
        (member.get("problem_id"), member.get("statement_revision"))
        for member in _array(set_amendment.get("additions", []), "v1 amendment additions")
        if isinstance(member, dict)
    }
    if amendment_keys != set_amendment_keys:
        raise CatalogError(f"{amendment_path}: additions do not match the v1 amendment")
    count_checks = (
        ("previous_member_count", len(initial_members)),
        ("added_member_count", len(amendment_keys)),
        ("effective_member_count", len(effective_members)),
    )
    for field, expected in count_checks:
        if _integer(amendment.get(field), f"{amendment_path}: {field}") != expected:
            raise CatalogError(f"{amendment_path}: {field} does not match v1 membership")

    active_amendment_count = 0
    for key, label in amendment_entries:
        problem_id, _revision = key
        if key not in effective_members or key in selection_keys:
            raise CatalogError(f"{label}: canonical amendment does not add a new v1 member")
        problem = problems.get(problem_id)
        if problem is None or not _history_contains(
            problem, status="active", effective_date=amendment_date
        ):
            raise CatalogError(
                f"manifests/problems/{problem_id}.toml: missing canonical v1 "
                f"active transition on {amendment_date}"
            )
        active_amendment_count += 1

    return active_initial_count, active_amendment_count, archived_count


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
    """Enforce lifecycle monotonicity and append-only frozen-set amendments."""
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
        if "initial_member_count" in old and (
            current.get("initial_member_count") != old["initial_member_count"]
        ):
            raise CatalogError(f"{relative}: initial_member_count is immutable")
        old_members = {
            (member.get("problem_id"), member.get("statement_revision"))
            for member in old.get("members", [])
        }
        new_members = {
            (member.get("problem_id"), member.get("statement_revision"))
            for member in current.get("members", [])
        }
        removed_members = old_members - new_members
        if removed_members:
            raise CatalogError(
                f"{relative}: members of a frozen set may not be removed or replaced"
            )

        old_amendments = old.get("amendments", [])
        new_amendments = current.get("amendments", [])
        if new_amendments[:len(old_amendments)] != old_amendments:
            raise CatalogError(f"{relative}: frozen-set amendments are append-only")
        appended_amendments = new_amendments[len(old_amendments):]
        declared_additions = {
            (member.get("problem_id"), member.get("statement_revision"))
            for amendment in appended_amendments
            for member in amendment.get("additions", [])
        }
        added_members = new_members - old_members
        if declared_additions != added_members:
            raise CatalogError(
                f"{relative}: every frozen-set addition requires one new amendment record"
            )


def validate(root: pathlib.Path, base_ref: str | None = None) -> tuple[int, int, int]:
    registry = load_tag_registry(root)
    problems, revisions = load_problems(root, registry)
    sets = load_sets(root, problems, revisions)
    validate_v1_lifecycle_cutover(root, problems, sets)
    if base_ref is not None:
        compare_with_base(root, base_ref, problems, sets)
    return len(problems), len(registry), len(sets)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=pathlib.Path, default=pathlib.Path("."))
    parser.add_argument("--base-ref", help="Git ref used to enforce append-only frozen sets")
    args = parser.parse_args()
    try:
        problem_count, tag_count, set_count = validate(args.root.resolve(), args.base_ref)
    except (CatalogError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"catalog validation failed: {error}\n")
    print(f"Catalog valid: {problem_count} problems, {tag_count} tags, {set_count} named sets.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
