import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

/-!
# Poincaré–Siegel linearisation theorem

If `f : ℂ → ℂ` is holomorphic near `0` with `f 0 = 0` and multiplier
`f'(0) = λ = e^{2πiα}` for a Diophantine `α`, then `f` is locally
analytically conjugate to the rotation `z ↦ λ z`: there is a holomorphic
germ `u(z) = z + O(z²)` with `f(u(z)) = u(λ z)` near `0` — an analytic
solution of the Schröder equation.
-/

/-- A real `α` is **Diophantine** if there are `C > 0` and `τ : ℝ` such
that `C / |q|^τ ≤ |α − p/q|` for all integers `p, q` with `q ≠ 0`. The
exponent τ is implicitly ≥ 2 by Dirichlet's theorem. This implies α is
irrational, so `e^{2πiα}` is not a root of unity. -/
def IsDiophantine (α : ℝ) : Prop :=
  ∃ C τ : ℝ, 0 < C ∧ ∀ p q : ℤ, q ≠ 0 →
    C / |(q : ℝ)| ^ τ ≤ |α - (p : ℝ) / (q : ℝ)|

/-- **Poincaré–Siegel linearisation theorem.** If `α` is Diophantine,
`λ = e^{2πiα}`, and `f` is holomorphic near `0` with `f 0 = 0` and
`f'(0) = λ`, then there is a holomorphic germ `u` with `u 0 = 0`,
`u'(0) = 1`, and `f(u z) = u(λ z)` for `z` near `0`. -/
@[eval_problem]
theorem poincare_siegel
    (α : ℝ) (_hα : IsDiophantine α)
    (lam : ℂ) (_hlam : lam = Complex.exp (2 * Real.pi * Complex.I * (α : ℂ)))
    (f : ℂ → ℂ) (_hf : AnalyticAt ℂ f 0) (_hf0 : f 0 = 0)
    (_hmult : deriv f 0 = lam) :
    ∃ u : ℂ → ℂ, AnalyticAt ℂ u 0 ∧ u 0 = 0 ∧ deriv u 0 = 1 ∧
      ∀ᶠ z in nhds (0 : ℂ), f (u z) = u (lam * z) := by
  sorry

end ComplexAnalysis
end LeanEval
