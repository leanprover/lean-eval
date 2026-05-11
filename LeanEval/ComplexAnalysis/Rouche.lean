import Mathlib.Analysis.Complex.ValueDistribution.LogCounting.Basic
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

open MeromorphicOn

/-!
Rouché's theorem (zero-count formulation, extended to the meromorphic case via divisors),
stated as equality of multiplicity-counted zero counts on the closed disk of radius `R`
centered at `0`.

The previous formulation used `ValueDistribution.logCounting f 0 R`, the **log-weighted**
Nevanlinna counting function — which is *not* the conclusion of Rouché. Under `‖g‖ < ‖f‖`
on the boundary, `f` and `f + g` have the same number of zeros (counted with multiplicity)
inside the disk, but the log-weighted count depends on where each zero sits. Concretely,
`f(z) = z` and `g(z) = -1/2` satisfy `|g| = 1/2 < 2 = |z| = |f|` on `|z| = 2`, yet
`logCounting f 0 2 = log 2` while `logCounting (f + g) 0 2 = log(2 / (1/2)) = log 4`.

We instead state the conclusion as the equality of the multiplicity sums of the zero
divisors of `f` and `f + g` taken on the closed disk of radius `R`.

We also require `f` to be in *normal form* (`MeromorphicNFOn`) rather than merely
`MeromorphicOn`. A bare `MeromorphicOn` hypothesis admits functions whose pointwise values
disagree with their meromorphic order at exceptional points (any `=ᶠ[codiscreteWithin]`
modification is still meromorphic), and that pointwise disagreement is enough to make the
divisor identity fail. See the Zulip discussion at
https://leanprover.zulipchat.com/#narrow/channel/583341-Model-comparisons-for-Lean/topic/LeanEval/near/593331158
for a concrete counterexample to the previous `MeromorphicOn`-only formulation.
-/

@[eval_problem]
theorem rouche_zero_count_eq
    {f g : ℂ → ℂ} {R : ℝ}
    (hR : 0 < R)
    (hf : MeromorphicNFOn f Set.univ)
    (hg : AnalyticOn ℂ g Set.univ)
    (hbound : ∀ z : ℂ, ‖z‖ = R → ‖g z‖ < ‖f z‖) :
    (∑ᶠ z, ((divisor (f + g) (Metric.closedBall 0 R))⁺) z) =
      (∑ᶠ z, ((divisor f (Metric.closedBall 0 R))⁺) z) := by
  sorry

end ComplexAnalysis
end LeanEval
