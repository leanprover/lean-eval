# Named problem sets

Each `<id>.toml` file defines a versioned set of problem statement revisions.
Set IDs use lowercase kebab-case. A draft set may change while `frozen = false`.
After a set is published with `frozen = true`, CI prevents deletion, unfreezing,
member removal or replacement, and rewriting previous amendment records.

```toml
schema_version = 1
id = "v1"
title = "LeanEval v1"
frozen = false
members = [
  { problem_id = "example", statement_revision = 1 },
]
```

A frozen set must also specify a canonical `published_at = "YYYY-MM-DD"`.

Schema 2 supports exceptional, explicitly authorized additions without
rewriting the original freeze. `initial_member_count` records the published
size. Each later addition appears in the effective `members` array and exactly
once in a dated, append-only amendment:

```toml
schema_version = 2
id = "v1"
title = "LeanEval v1"
frozen = true
published_at = "2026-08-20"
initial_member_count = 1
members = [
  { problem_id = "example", statement_revision = 1 },
  { problem_id = "later-example", statement_revision = 1 },
]

[[amendments]]
id = "2026-08-21-add-later-example"
effective_date = "2026-08-21"
reason = "Explicit maintainer addition."
authorization = "Maintainer decision recorded in issue 123."
additions = [
  { problem_id = "later-example", statement_revision = 1 },
]
```
