import Mathlib.Analysis.Distribution.SchwartzSpace.Fourier
import EvalTools.Markers

namespace LeanEval.Analysis.RadchenkoViazovskaInterpolation

/-!
# Fourier interpolation on the real line

Radchenko and Viazovska proved that an even Schwartz function on the real
line is determined by the values of the function and its Fourier transform
at the points `sqrt n`, for nonnegative integers `n`. Their stronger theorem
gives an explicit interpolation formula. The uniqueness consequence below
states injectivity of the sampling map.

Mathlib's Fourier transform uses the same `exp (-2 * pi * I * x * ξ)`
normalization as the interpolation theorem.
-/

open scoped FourierTransform SchwartzMap

/-- **Radchenko-Viazovska Fourier interpolation uniqueness theorem.**
An even Schwartz function on `ℝ` whose values and Fourier-transform values
vanish at every `sqrt n` is identically zero. -/
@[eval_problem]
theorem radchenko_viazovska_fourier_interpolation
    (f : 𝓢(ℝ, ℂ)) (heven : Function.Even f)
    (hf : ∀ n : ℕ, f (Real.sqrt n) = 0)
    (hfourier : ∀ n : ℕ, (𝓕 f) (Real.sqrt n) = 0) :
    f = 0 := by
  sorry

end LeanEval.Analysis.RadchenkoViazovskaInterpolation
