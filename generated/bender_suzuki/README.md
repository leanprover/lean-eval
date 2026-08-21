# `bender_suzuki`

Bender–Suzuki theorem (classification of finite simple groups with a strongly-embedded subgroup)

- Problem ID: `bender_suzuki`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Tianjiao Nie
- Notes: For a finite simple group X with a strongly-embedded subgroup M, it is PSL, PSU, or Sz.
- Source: D. Gorenstein, R. Lyons, and R. Solomon, The classification of the finite simple groups, Number 2

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
