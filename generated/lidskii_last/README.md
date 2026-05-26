# `lidskii_last`

Lidskii–Last eigenvalue-perturbation theorem

- Problem ID: `lidskii_last`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §99 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. For two self-adjoint complex n×n matrices A, B with eigenvalues sorted in the same order, the total eigenvalue displacement ∑|α_j - β_j| is bounded by the entrywise ℓ¹ distance ∑|A_ij - B_ij|. This is Last's theorem (≈1993), a consequence of Lidskii's inequality (1950). Uses Matrix.IsHermitian.eigenvalues₀; mathlib has no Lidskii, Ky Fan, or Hoffman-Wielandt perturbation bounds, and no formalization of the theorem was found in any other proof assistant.
- Source: V. B. Lidskii (1950); the entrywise ℓ¹ form is due to Y. Last (around 1993). Listed as §99 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: By Lidskii's inequality the vector of sorted-eigenvalue displacements of A and B is majorized by the vector of eigenvalues of C := B - A (proved via the Ky Fan extremal characterization of partial sums of eigenvalues), so ∑_j |α_j - β_j| ≤ ∑_j |γ_j| with γ the eigenvalues of C. Then ∑_j |γ_j| ≤ ∑_{i,j} |C_ij|: for Hermitian C the ℓ¹ norm of the eigenvalues is dominated by the ℓ¹ norm of the matrix entries (bound each |γ_j| using the spectral decomposition and the triangle inequality). Combining the two gives the entrywise bound.

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
