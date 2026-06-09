# `moran_equality_affine`

Moran's equality for affine-symmetric iterated function systems

- Problem ID: `moran_equality_affine`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For an iterated function system on ℝᵈ whose maps are affine with a common contraction factor λ ∈ (0,1) and orthogonal linear parts, satisfying the open set condition, the Hausdorff dimension of the attractor equals the similarity dimension −log n / log λ. The trusted helpers (IsAttractor, IsAffineSymmetricIFS, OpenSetCondition) are non-holes. Mathlib has dimH, μH[d], and ContractingWith but no iterated function systems / Hutchinson operator / attractor / similarity dimension. Candidate from §105 of the Knill survey.
- Source: P. A. P. Moran, *Additive functions of intervals and Hausdorff measure*, Proc. Cambridge Philos. Soc. 42 (1946); J. E. Hutchinson, *Fractals and self similarity*, Indiana Univ. Math. J. 30 (1981). Knill, *Some fundamental theorems in mathematics*, §105.
- Informal solution: Two inequalities. Upper bound (dimH S ≤ s with ∑ λˢ = n·λˢ = 1, i.e. s = −log n/log λ): cover S by the n^k cylinder images of diameter λᵏ·diam(S) under length-k words, giving ∑ diam^s = n^k·(λᵏ diam)^s = (n λˢ)^k diam^s = diam^s bounded, so the s-dimensional Hausdorff measure is finite and dimH S ≤ s. Lower bound (the open set condition): use the OSC to build a mass distribution (the natural self-similar measure giving each length-k cylinder mass n^{-k}) and apply the mass distribution principle — bounded overlap from the disjoint open sets fᵢ(G) gives μ(B_r) ≤ C r^s, forcing μH^s(S) > 0 and dimH S ≥ s. Hence equality.

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
