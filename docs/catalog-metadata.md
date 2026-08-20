# Catalog metadata

Every file in `manifests/problems/` identifies one versioned benchmark problem.
The catalog validator is the source of truth for lifecycle, tags, and named sets:

```bash
python scripts/validate_catalog.py
```

## Current fields

- `group` is one of `formalization-evaluation`, `software-verification`, or
  `open-conjectures`.
- `status` is one of `draft`, `active`, or `archived`.
- `visible` controls public catalog presentation independently of lifecycle.
- `statement_revision` is a positive integer and never decreases.
- `tags` contains unique keys registered in `manifests/tags.toml`.

The initial metadata migration establishes revision 1 and draft status without
history rows. A later status transition appends a `[[status_history]]` table:

```toml
[[status_history]]
status = "active"
effective_date = "2026-08-20"
reason = "policy"
```

A later statement revision appends a `[[revision_history]]` table. Its digest is
the review-time digest of the trusted statement representation used by the
revision process; it is not a digest of an entire shared Lean module.

```toml
[[revision_history]]
revision = 2
effective_date = "2026-08-20"
reason = "statement-change"
statement_digest = "sha256:<64 lowercase hex digits>"
```

History is append-only relative to the CI base. Dates and revisions increase
strictly, and the final row must describe the current status or revision.
Allowed reason categories are `initial`,
`statement-change`, `policy`, `correction`, `retraction`, and `restoration`.

## Named sets

Files in `manifests/sets/` list exact `(problem_id, statement_revision)` pairs.
Once `frozen = true`, comparison with the CI base revision makes membership
immutable. Corrections and retractions therefore remain visible historically
and are represented through lifecycle metadata rather than deleting members.

## v1 evidence

The audit tool reads either schema-v1 or schema-v2 result files and emits stable
JSON and Markdown solve-count reports:

```bash
python scripts/v1_audit.py \
  --results-dir ../lean-eval-submissions/results \
  --json-output v1-evidence.json \
  --markdown-output v1-evidence.md
```

The report includes every catalog problem and any unknown result IDs. It does
not recommend or select v1 membership.
