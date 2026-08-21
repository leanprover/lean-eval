# LeanEval v1 set

The published `v1` set initially contained 118 exact problem statement
revisions. Membership was selected mechanically on 2026-08-20 from results
commit `269c4dc9e3d264fe6b06e7d5d2fd1b0d86ac17e4`:

- catalog group `formalization-evaluation`;
- `visible = true`;
- fewer than three accepted result records; and
- zero accepted records whose submitted source was public.

There were no manual additions or exclusions in that initial selection. The
two software-verification drafts were not candidates because they belong to
the separate `software-verification` group. The complete 299-problem evidence is checked in
as [`selection-2026-08-20.json`](../audits/v1/selection-2026-08-20.json) and a
human-readable [Markdown table](../audits/v1/selection-2026-08-20.md). The JSON
evidence SHA-256 is
`336be9fcafa4730cd0daf4598d30ae10104c3f733a08aeef48ae2357a2518817`.

On 2026-08-21, the maintainer explicitly amended v1 to add ten newly merged
evaluation problems at statement revision 1. The effective set therefore has
128 members. The machine-readable amendment record, including the ten PRs and
merge commits, is
[`amendment-2026-08-21.json`](../audits/v1/amendment-2026-08-21.json).
This amendment does not retroactively alter the original 118-member selection
evidence.

The set remains published with `frozen = true`. Catalog validation prevents
deletion, unfreezing, removal or replacement of a member, and rewriting an
existing amendment. Any exceptional addition requires a later-dated,
append-only amendment naming the exact `(problem_id, statement_revision)`
pairs and its authorization.
