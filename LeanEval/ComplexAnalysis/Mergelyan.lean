import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

/-!
# Mergelyan's theorem (Sergey Mergelyan, 1951)

§64 (additional statement 4) of Knill's *Some Fundamental Theorems in
Mathematics*. For a compact `K ⊆ ℂ` with connected complement, every
continuous `f : ℂ → ℂ` that is holomorphic on the interior of `K` is the
uniform limit on `K` of complex polynomials.

Mergelyan extends Runge's theorem (rational approximation on compact
sets) to polynomial approximation under the connected-complement
hypothesis, and extends Weierstrass approximation from real intervals
to complex compacts in ℂ.

Mathlib has Weierstrass and Stone–Weierstrass for `C([a, b], ℝ)` and
the Bernstein approximation, but `grep -rn 'mergelyan'` in mathlib
returns no hits. Aristotle proved the entire-function step
`entire_to_poly` (Taylor partial sums approximate entire functions
uniformly on compacta) sorry-free, and reduced Mergelyan to
`entire_approx` — the ∂̄-equation step that needs the Cauchy–Green /
Pompeiu operator, not in mathlib.
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
