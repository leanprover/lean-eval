import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis

/-!
# Mandelbar (tricorn) is not path-connected

The `d = 2` case of Hubbard–Schleicher's theorem that multicorns — the
connectedness loci of unicritical antiholomorphic polynomials
`z ↦ z̄^d + c` — are not path-connected for `d ≥ 2`. For `d = 2` the
multicorn is the mandelbar / tricorn, the connectedness locus of
`z ↦ z̄² + c`.

Knill lists this as §62 additional statement 2 but writes the iterator
as `z ↦ z̄ + c` (degree 1). That literal map has bounded critical orbit
iff `Re c = 0`, so its connectedness locus is the imaginary axis —
path-connected, contradicting the claim. The formal statement here
uses the standard quadratic antiholomorphic family `z ↦ z̄² + c`.
-/

open Function

/-- The antiholomorphic mandelbar iterator `T̄_c(z) = z̄² + c`. -/
def Tantibar (c : ℂ) (z : ℂ) : ℂ := (starRingEnd ℂ z) ^ 2 + c

/-- The **mandelbar set** (tricorn): connectedness locus of `z ↦ z̄² + c`. -/
def Mandelbar : Set ℂ :=
  { c : ℂ | ∃ M : ℝ, ∀ n : ℕ, ‖(Tantibar c)^[n] 0‖ ≤ M }

/-- **The mandelbar (tricorn) is not path-connected** (Hubbard–Schleicher). -/
@[eval_problem]
theorem mandelbar_not_path_connected : ¬ IsPathConnected Mandelbar := by
  sorry

end ComplexAnalysis
end LeanEval
