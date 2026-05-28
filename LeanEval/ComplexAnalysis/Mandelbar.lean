import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

/-!
# Mandelbar (tricorn) is not path-connected (Hubbard–Inou–Schleicher, 2009)

§62 (additional statement 2) of Knill's *Some Fundamental Theorems in
Mathematics*. The **mandelbar set** (also called the *tricorn*) is the
connectedness locus of the antiholomorphic family `z ↦ z̄² + c`:
`Mandelbar = { c ∈ ℂ | (T̄_c)^n(0) stays bounded }`. The Hubbard–Inou–
Schleicher theorem states that the mandelbar is **not** path-connected.

## Note on Knill's typo

Knill writes the antiholomorphic iterator as `z ↦ z̄ + c` (degree 1).
With that literal map the orbit of `0` is
`0, c, 2 Re c, 2 Re c + c, …`, bounded iff `Re c = 0`, so the
connectedness locus is the imaginary axis — which **is** path-connected,
contradicting the claim. The result Knill refers to is the standard
**degree-2** mandelbar / tricorn `z ↦ z̄² + c` of Hubbard–Inou–Schleicher;
this file formalises that (corrected) statement.

Mathlib has `Function.iterate`, `IsPathConnected`, and `starRingEnd ℂ`
for complex conjugation, but no mandelbar / tricorn definition. The
proof uses parabolic-implosion arguments on the parabolic-arc ears of
the mandelbar's hyperbolic components (Hubbard–Inou–Schleicher 2009).
-/

open Function

/-- The antiholomorphic mandelbar iterator `T̄_c(z) = z̄² + c`. -/
def Tantibar (c : ℂ) (z : ℂ) : ℂ := (starRingEnd ℂ z) ^ 2 + c

/-- The **mandelbar set** (tricorn): connectedness locus of `z ↦ z̄² + c`. -/
def Mandelbar : Set ℂ :=
  { c : ℂ | ∃ M : ℝ, ∀ n : ℕ, ‖(Tantibar c)^[n] 0‖ ≤ M }

/-- **The mandelbar is not path-connected** (Hubbard–Inou–Schleicher, 2009). -/
@[eval_problem]
theorem mandelbar_not_path_connected : ¬ IsPathConnected Mandelbar := by
  sorry

end ComplexAnalysis
end LeanEval
