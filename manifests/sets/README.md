# Named problem sets

Each `<id>.toml` file defines a versioned set of problem statement revisions.
Set IDs use lowercase kebab-case. A draft set may change while `frozen = false`.
After a set is published with `frozen = true`, CI prevents deletion, unfreezing,
or any change to its `(problem_id, statement_revision)` membership.

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
