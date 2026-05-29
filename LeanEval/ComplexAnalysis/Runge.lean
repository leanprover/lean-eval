import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

/-!
# Runge's theorem

Basic Runge approximation theorem for compact subsets of `ℂ`: if `K` is
compact and `f` is analytic on an open neighbourhood of `K`, then `f`
can be uniformly approximated on `K` by rational functions with no
poles on `K`.

This is the basic form. It does not include the standard pole-control
refinement, where poles may be chosen from prescribed points, one in
each connected component of `ℂ \ K`.
-/

open scoped Polynomial

/-- **Runge's theorem.** If `K ⊆ ℂ` is compact and `f` is analytic on
an open neighbourhood of `K`, then for every `ε > 0`, `f` is uniformly
approximated on `K` by a rational function `p / q` with `q` non-vanishing
on `K`. -/
@[eval_problem]
theorem runge (K : Set ℂ) (_hK : IsCompact K) (U : Set ℂ) (_hU : IsOpen U)
    (_hKU : K ⊆ U) (f : ℂ → ℂ) (_hf : AnalyticOnNhd ℂ f U)
    (ε : ℝ) (_hε : 0 < ε) :
    ∃ p q : ℂ[X], (∀ z ∈ K, q.eval z ≠ 0) ∧
      (∀ z ∈ K, ‖f z - p.eval z / q.eval z‖ < ε) := by
  sorry

end ComplexAnalysis
end LeanEval
