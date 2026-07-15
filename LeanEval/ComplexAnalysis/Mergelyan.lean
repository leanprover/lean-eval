import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

/-!
# Mergelyan's theorem

For a compact set `K ⊆ ℂ` with connected complement, every function
continuous on `K` and holomorphic on `interior K` is uniformly
approximable on `K` by complex polynomials.

This is the standard polynomial-approximation form of Mergelyan's
theorem.
-/

open scoped Polynomial

/-- **Mergelyan's theorem.** For a compact `K ⊆ ℂ` with connected
complement and `f : ℂ → ℂ` continuous on `K` and analytic on the
interior of `K`, every `ε > 0` admits a complex polynomial `p` with
`‖f z − p(z)‖ < ε` on `K`. -/
@[eval_problem]
theorem mergelyan (K : Set ℂ) (_hK : IsCompact K) (_hKc : IsConnected (Kᶜ))
    (f : ℂ → ℂ) (_hfc : ContinuousOn f K) (_hfh : AnalyticOnNhd ℂ f (interior K))
    (ε : ℝ) (_hε : 0 < ε) :
    ∃ p : ℂ[X], ∀ z ∈ K, ‖f z - p.eval z‖ < ε := by
  sorry

end ComplexAnalysis
end LeanEval
