# `pi3_sphere_two_mulEquiv_int`

pi_3 of the 2-sphere is Z

- Problem ID: `pi3_sphere_two_mulEquiv_int`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: The classical computation pi_3(S^2) = Z, with an explicit basepoint.
- Source: Classical theorem in algebraic topology.
- Informal solution: Use the Hopf fibration to identify the third homotopy group of the 2-sphere with the integers.

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
