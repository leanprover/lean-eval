import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis
namespace MandelbrotProblem

/-!
# Mandelbrot set is connected (Douady–Hubbard)

The Mandelbrot set `M = { c ∈ ℂ | T_c^n(0) stays bounded }`, where
`T_c(z) = z² + c`, is the parameter set for which the critical orbit
of `0` under the quadratic family is bounded. Douady and Hubbard proved
in 1982 (full development 1984–85) that `M` is connected.
-/

open Function

/-- The quadratic family member `T_c(z) = z² + c`. -/
def Tc (c : ℂ) (z : ℂ) : ℂ := z ^ 2 + c

/-- The **Mandelbrot set** `M = { c ∈ ℂ | T_c^n(0) stays bounded }`. -/
def Mandelbrot : Set ℂ :=
  { c : ℂ | ∃ M : ℝ, ∀ n : ℕ, ‖(Tc c)^[n] 0‖ ≤ M }

/-- **Mandelbrot set is connected** (Douady–Hubbard). -/
@[eval_problem]
theorem mandelbrot_connected : IsConnected Mandelbrot := by
  sorry

end MandelbrotProblem
end ComplexAnalysis
end LeanEval
