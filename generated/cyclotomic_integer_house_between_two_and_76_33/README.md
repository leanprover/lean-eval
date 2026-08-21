# `cyclotomic_integer_house_between_two_and_76_33`

Real cyclotomic integer with house in (2, 76/33)

- Problem ID: `cyclotomic_integer_house_between_two_and_76_33`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: The 2 < house < 76/33 branch of Theorem 1.0.5 from Calegari--Morrison--Snyder, stated using Mathlib's NumberField.house.
- Source: https://arxiv.org/pdf/1004.0665
- Informal solution: If the house lies in (2, 76/33), then it is one of the five explicitly listed values.

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
