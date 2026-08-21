# LeanEval v1 set

The frozen `v1` set contains 118 exact problem statement revisions. Membership
was selected mechanically on 2026-08-20 from results commit
`269c4dc9e3d264fe6b06e7d5d2fd1b0d86ac17e4`:

- catalog group `formalization-evaluation`;
- `visible = true`;
- fewer than three accepted result records; and
- zero accepted records whose submitted source was public.

There are no manual additions or exclusions. The two software-verification
drafts are not candidates because they belong to the separate
`software-verification` group. The complete 299-problem evidence is checked in
as [`selection-2026-08-20.json`](../audits/v1/selection-2026-08-20.json) and a
human-readable [Markdown table](../audits/v1/selection-2026-08-20.md). The JSON
evidence SHA-256 is
`336be9fcafa4730cd0daf4598d30ae10104c3f733a08aeef48ae2357a2518817`.

The set is published with `frozen = true`. Catalog validation prevents later
deletion, unfreezing, or membership changes after this commit reaches `main`.
Lifecycle corrections remain possible through the append-only problem history
without changing the frozen `(problem_id, statement_revision)` pairs.
