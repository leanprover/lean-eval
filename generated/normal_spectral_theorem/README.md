# `normal_spectral_theorem`

Normal spectral theorem

- Problem ID: `normal_spectral_theorem`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A complex matrix A is normal (IsStarNormal A, i.e. Aᴴ A = A Aᴴ) iff it is unitarily diagonalizable, A = U (diagonal d) Uᴴ with U unitary. Mathlib has the Hermitian special case (Matrix.IsHermitian.spectral_theorem) and all conjugation/diagonal machinery, but not the normal generalization (no Matrix.IsStarNormal.spectral_theorem). The forward implication (a normal matrix admits an orthonormal eigenbasis) is the substantive content; the converse is a short computation. No new definitions beyond IsStarNormal, unitary, and Matrix.diagonal. Category-(b) candidate.
- Source: Knill, *Some fundamental theorems in mathematics*, §14.
- Informal solution: Forward: a normal matrix commutes with its conjugate transpose, so by simultaneous unitary triangularization (Schur) the triangular factor is itself normal, hence diagonal; the columns of the Schur unitary form an orthonormal eigenbasis, giving A = U (diagonal d) Uᴴ. Reverse: if A = U (diagonal d) Uᴴ with U unitary, then Aᴴ = U (diagonal d̄) Uᴴ and the two diagonal matrices commute, so A and Aᴴ commute, i.e. A is normal.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
