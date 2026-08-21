# `pi_succ_sphere_n_mulEquiv_zmod_two`

pi_(n+1) of S^n is Z/2 for n at least 3

- Problem ID: `pi_succ_sphere_n_mulEquiv_zmod_two`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: A concrete stable-family homotopy-group computation.
- Source: Classical theorem in unstable homotopy theory.
- Informal solution: Use suspension and the stable range to show the first stable stem is Z/2.

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
