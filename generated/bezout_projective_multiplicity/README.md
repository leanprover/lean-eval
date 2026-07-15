# `bezout_projective_multiplicity`

Bézout's theorem (projective, with multiplicity)

- Problem ID: `bezout_projective_multiplicity`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For n homogeneous polynomials f_k of total degrees d_k ≥ 1 in n + 1 variables over an algebraically closed field with finite common projective zero set, the sum of intersection multiplicities equals ∏ d_k (equation in ℕ∞). The intersection multiplicity is constructed via the affine cone (Eisenbud Ch. 12): pick an index i with p.rep i ≠ 0, normalise the i-th coordinate to 1, localise K[X_0, …, X_n] at the maximal ideal of the resulting affine point, and take Module.length K of the quotient by (f_1, …, f_n, X_i − 1). §50 of Knill's 'Some Fundamental Theorems in Mathematics'.
- Source: É. Bézout, *Théorie générale des équations algébriques*, Paris, 1779. Modern projective formulation: see Eisenbud, *Commutative Algebra*, Chapter 12, or Hartshorne, *Algebraic Geometry*, Ch. I §7. Listed as §50 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Standard proof via Hilbert series: cutting the homogeneous coordinate ring K[X_0, …, X_n] by the regular sequence f_1, …, f_n gives an Artinian graded algebra whose total length is ∏ d_k (Macaulay 1916). The local-Hilbert-series decomposition redistributes this length as a sum over the finitely many intersection points. Alternative deformation proof: degenerate the f_k continuously to f̃_k = ∏_j (X_{k+1} − α_{k,j} · X_0) for distinct α_{k,j} ∈ K; the deformed intersection has exactly ∏ d_k transverse points (multiplicity 1 each); continuity of the Hilbert function under flat families shows the multiplicity sum is preserved.

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
