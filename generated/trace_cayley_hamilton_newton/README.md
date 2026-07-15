# `trace_cayley_hamilton_newton`

Trace Cayley-Hamilton / Newton identity

- Problem ID: `trace_cayley_hamilton_newton`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The Newton trace recurrence for the coefficients of the characteristic polynomial: k cₖ + ∑_{j=1}^k tr(Aʲ) c_{k-j} = 0, where χ_A(X) = Xᴺ + c₁ Xᴺ⁻¹ + ⋯ + c_N. The helper charpolyDescendingCoeff packages cₖ as the degree N−k coefficient of Matrix.charpoly (zero for k > N), so the recurrence holds uniformly for all positive k. Mathlib has Cayley-Hamilton (Matrix.aeval_self_charpoly) but not the Newton trace identity relating power sums tr(Aʲ) to the elementary-symmetric charpoly coefficients. Category-(b) candidate.
- Source: Knill, *Some fundamental theorems in mathematics*, §220.
- Informal solution: These are Newton's identities relating the power sums pⱼ = tr(Aʲ) (sums of j-th powers of eigenvalues) to the elementary symmetric functions eₖ that appear, up to sign, as the charpoly coefficients cₖ = (−1)ᵏ eₖ. Prove by the standard generating-function / logarithmic-derivative argument: differentiate log det(X·1 − A) = ∑ log(X − λᵢ), expand 1/(X − λᵢ) as a power series in 1/X to get ∑ⱼ pⱼ X^{−j}, and match coefficients against the derivative of the charpoly to obtain k cₖ + ∑_{j=1}^k pⱼ c_{k−j} = 0. For k > N the relation is the trace of A^{k−N} times Cayley-Hamilton.

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
