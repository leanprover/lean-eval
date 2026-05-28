import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

/-!
# Poincaré–Siegel linearisation theorem (Siegel, 1942)

§83 (additional statement 1) of Knill's *Some Fundamental Theorems in
Mathematics*. If `f : ℂ → ℂ` is holomorphic near `0` with `f 0 = 0` and
multiplier `f'(0) = λ = e^{2πiα}` for a Diophantine `α`, then `f` is
locally analytically conjugate to the rotation `z ↦ λ z`: there is a
holomorphic germ `u(z) = z + O(z²)` (i.e. `u 0 = 0`, `u'(0) = 1`) with

  `f(u(z)) = u(λ z)`  near  `0`.

The conjugacy `u` is an analytic solution of the Schröder equation.

Mathlib has `AnalyticAt` and `deriv`, so the statement elaborates with
no new definitions beyond `IsDiophantine`. The only Lean trace of
Siegel's theorem is a passing citation in
`Mathlib/Analysis/Analytic/Inverse.lean`; the theorem itself is absent.
The proof uses the **majorant series** technique to handle the small
divisors `(λⁿ − 1)⁻¹` arising in the formal power-series conjugacy.
-/

/-- A real `α` is **Diophantine** (exponent 2) if there is `C > 0` with
`C / q² ≤ |α − p/q|` for all integers `p, q` with `q ≠ 0`. -/
def IsDiophantine (α : ℝ) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ p q : ℤ, q ≠ 0 →
    C / (q : ℝ) ^ 2 ≤ |α - (p : ℝ) / (q : ℝ)|

/-- **Poincaré–Siegel linearisation theorem.** If `α` is Diophantine,
`λ = e^{2πiα}`, and `f` is holomorphic near `0` with `f 0 = 0` and
`f'(0) = λ`, then there is a holomorphic germ `u` with `u 0 = 0`,
`u'(0) = 1`, and `f(u z) = u(λ z)` for `z` near `0`. -/
@[eval_problem]
theorem poincare_siegel
    (α : ℝ) (_hα : IsDiophantine α)
    (lam : ℂ) (_hlam : lam = Complex.exp (2 * Real.pi * (α : ℂ) * Complex.I))
    (f : ℂ → ℂ) (_hf : AnalyticAt ℂ f 0) (_hf0 : f 0 = 0)
    (_hmult : deriv f 0 = lam) :
    ∃ u : ℂ → ℂ, AnalyticAt ℂ u 0 ∧ u 0 = 0 ∧ deriv u 0 = 1 ∧
      ∀ᶠ z in nhds (0 : ℂ), f (u z) = u (lam * z) := by
  sorry

end ComplexAnalysis
end LeanEval
