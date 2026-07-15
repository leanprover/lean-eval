import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ComplexAnalysis
namespace FatouJuliaProblem

/-!
# Fatou–Julia / Cantor dichotomy

For the quadratic family `T_c(z) = z² + c`, the filled Julia set
`K_c = { z ∈ ℂ | T_c^n(z) stays bounded }` satisfies:

- `c ∈ M` (Mandelbrot set) implies `K_c` is connected;
- `c ∉ M` implies `K_c` is homeomorphic to the Cantor space `ℕ → Bool`.

For quadratic polynomials, the usual Julia set is `∂K_c`. The submitted
statement uses the filled Julia set `K_c`; this is equivalent for the
dichotomy here, since connectedness of `K_c` is equivalent to
connectedness of `∂K_c`, and in the escaping case `K_c = ∂K_c` is a
Cantor set.
-/

open Function

/-- The quadratic family member `T_c(z) = z² + c`. -/
def Tc (c : ℂ) (z : ℂ) : ℂ := z ^ 2 + c

/-- The Mandelbrot set `M = { c ∈ ℂ | T_c^n(0) stays bounded }`. -/
def Mandelbrot : Set ℂ :=
  { c : ℂ | ∃ M : ℝ, ∀ n : ℕ, ‖(Tc c)^[n] 0‖ ≤ M }

/-- The filled Julia set `K_c = { z ∈ ℂ | T_c^n(z) stays bounded }`. -/
def FilledJulia (c : ℂ) : Set ℂ :=
  { z : ℂ | ∃ M : ℝ, ∀ n : ℕ, ‖(Tc c)^[n] z‖ ≤ M }

/-- **Fatou–Julia dichotomy.** For the quadratic family, `c ∈ M` implies
the filled Julia set `K_c` is connected; `c ∉ M` implies `K_c` is
homeomorphic to the Cantor space `ℕ → Bool`. -/
@[eval_problem]
theorem julia_cantor_dichotomy (c : ℂ) :
    (c ∈ Mandelbrot → IsConnected (FilledJulia c)) ∧
    (c ∉ Mandelbrot → Nonempty ((FilledJulia c) ≃ₜ (ℕ → Bool))) := by
  sorry

end FatouJuliaProblem
end ComplexAnalysis
end LeanEval
