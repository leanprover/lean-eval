import Mathlib
import EvalTools.Markers

namespace LeanEval.NumberTheory.Lindemann

/-!
# Lindemann's theorem and the Lindemann–Weierstrass theorem

`lindemann`: both `e = exp 1` and `π` are transcendental (Lindemann 1882).
`lindemann_weierstrass`: ℚ-linearly independent algebraic numbers have
algebraically independent exponentials. Mathlib has `Transcendental`,
`AlgebraicIndependent`, and the *analytic* scaffolding of the proof
(`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`), but neither
theorem statement. (The companion irrationality of `π` is already in Mathlib
as `irrational_pi`, so it is not a candidate.)

Category-(b) candidates from §55 of the Knill survey.
-/

open Polynomial

/-- **Lindemann's theorem.** Both `e = exp 1` and `π` are transcendental over
`ℤ`. -/
@[eval_problem]
theorem lindemann :
    Transcendental ℤ (Real.exp 1) ∧ Transcendental ℤ Real.pi := by
  sorry

/-- **Lindemann–Weierstrass theorem.** If `x₁, …, xₙ ∈ ℂ` are algebraic over `ℚ`
and ℚ-linearly independent, then `e^{x₁}, …, e^{xₙ}` are algebraically
independent over `ℚ`. -/
@[eval_problem]
theorem lindemann_weierstrass {n : ℕ} (x : Fin n → ℂ)
    (h_alg : ∀ i, IsAlgebraic ℚ (x i))
    (h_lin : LinearIndependent ℚ x) :
    AlgebraicIndependent ℚ (fun i => Complex.exp (x i)) := by
  sorry

end LeanEval.NumberTheory.Lindemann
