import Mathlib

namespace LeanEval.Analysis.RadonTransform

/-!
# The Radon transform: Fourier-slice diagonalization and pseudo-inversion

`radon_can_be_diagonalized_and_pseudo_inverted`: the Fourier slice theorem
(`fourier1` of `radon φ(·,θ)` equals a 2D-Fourier slice of `φ`), together with
the existence of a left inverse of the Radon transform on Schwartz functions.
The trusted helpers (`radon`, `fourier1`, `fourier2`) are non-holes. Mathlib
has the 1D/2D Fourier transforms and Schwartz space but no Radon transform,
Fourier slice theorem, or filtered back-projection.

Category-(b) candidate from §100 of the Knill survey.
-/

open MeasureTheory Real Complex

/-- The **Radon transform** of `f : ℝ × ℝ → ℂ` at `(p, θ)`: the integral of `f`
along the line `x cos θ + y sin θ = p`. -/
noncomputable def radon (f : ℝ × ℝ → ℂ) (pθ : ℝ × ℝ) : ℂ :=
  ∫ t : ℝ, f (pθ.1 * Real.cos pθ.2 - t * Real.sin pθ.2,
              pθ.1 * Real.sin pθ.2 + t * Real.cos pθ.2)

/-- 1D Fourier transform (mathlib's `2π i` convention). -/
noncomputable def fourier1 (g : ℝ → ℂ) (k : ℝ) : ℂ :=
  ∫ p : ℝ, Complex.exp (-(2 * Real.pi * p * k) * Complex.I) * g p

/-- 2D Fourier transform of `f : ℝ × ℝ → ℂ` at `(k₁, k₂)`. -/
noncomputable def fourier2 (f : ℝ × ℝ → ℂ) (k : ℝ × ℝ) : ℂ :=
  ∫ x : ℝ × ℝ,
    Complex.exp (-(2 * Real.pi * (x.1 * k.1 + x.2 * k.2)) * Complex.I) * f x



end LeanEval.Analysis.RadonTransform
