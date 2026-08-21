# `irreducible_nonnegative_matrix_has_positive_eigenvector_at_spectralRadius`

Perron-Frobenius for irreducible nonnegative matrices

- Problem ID: `irreducible_nonnegative_matrix_has_positive_eigenvector_at_spectralRadius`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: A Perron-Frobenius style eigenvector existence statement at the spectral radius.
- Source: Classical theorem in linear algebra.
- Informal solution: Show that an irreducible nonnegative matrix has a strictly positive eigenvector with eigenvalue equal to its spectral radius.

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
