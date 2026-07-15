# `sard_theorem`

Sard's theorem (critical-set image has measure zero)

- Problem ID: `sard_theorem`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a smooth map f : ℝᵐ → ℝⁿ, the image of the rank-deficient locus {x | rank df(x) < m ∧ rank df(x) < n} has Lebesgue measure zero. This is Knill's specific phrasing — the standard textbook Sard theorem uses the larger critical set {x | rank df(x) < n} (failure of surjectivity), which is a weaker hypothesis, so textbook Sard *implies* the form proved here. The two agree when m ≥ n; for m < n a smooth immersion has every point critical under the textbook definition but no critical points under Knill's. The manifold form follows chart-by-chart from this Euclidean version. Mathlib has the equal-dimension case (`addHaar_image_eq_zero_of_det_fderivWithin_eq_zero`) when det df = 0, plus topological corollaries via Hausdorff dimension (`ContDiff.dense_compl_range_of_finrank_lt_finrank`), but no general critical-value / Sard statement. §125 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: A.P. Morse, 'The behavior of a function on its critical set', Ann. of Math. (2) 40 (1939) 62–70; A. Sard, 'The measure of the critical values of differentiable maps', Bull. Amer. Math. Soc. 48 (1942) 883–890. §125 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The classical proof stratifies the critical set by rank, applies the implicit function theorem to straighten `f` locally on each stratum into a normal form, and bounds the image with Taylor estimates plus Fubini and countable covers. The standard regularity threshold is `C^k` for `k ≥ max(m − n + 1, 1)` (Whitney's threshold for the surjectivity-failure form); the smooth (`C^∞`) hypothesis used here is stronger than needed. Knill's rank-deficient form is implied by the textbook surjectivity-failure form. Mathlib has the equal-dimension Jacobian-determinant lemma (`addHaar_image_eq_zero_of_det_fderivWithin_eq_zero`) and Hausdorff-dimension topological corollaries, but not the rank-stratification / normal-form / Fubini-and-cover machinery, and not the general critical-value Sard statement.

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
