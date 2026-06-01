import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Wiener's atom-detection formula

§66 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. For a
probability measure `μ` on the circle `𝕋 = ℝ/2πℤ` with Fourier coefficients
`μ̂_k = ∫ e^{ikx} dμ(x)`, the Cesàro average of `|μ̂_k|²` converges to the sum of
the squared masses of the atoms of `μ`:
`lim_{N→∞} (1/N) ∑_{k=1}^{N} |μ̂_k|² = ∑_{x} μ({x})²`.
The Cesàro average of squared Fourier moduli detects exactly the pure-point part
of `μ`.

mathlib provides `AddCircle`, the Fourier characters `fourier`, and related
Fourier theory for functions, but it does not package Fourier coefficients of
measures or this Wiener atom-detection theorem (`grep -rn 'Wiener' Mathlib/`
finds no result on `lim (1/N) ∑ |μ̂_k|²` for measures on the circle). The
one-line measure coefficient `fourierCoeffMeasure μ k := ∫ x, fourier k x ∂μ` is
supplied here.
-/

open MeasureTheory Filter Topology Real Complex

/-- The `k`-th Fourier coefficient of a Borel measure `μ` on the circle
`AddCircle (2π)`: `μ̂_k := ∫ exp(i k x) dμ(x)`. With mathlib's normalisation
`fourier k x = exp(2π i k x / T)`, taking `T = 2π` gives `exp(i k x)`. -/
noncomputable def fourierCoeffMeasure (μ : Measure (AddCircle (2 * Real.pi)))
    (k : ℤ) : ℂ :=
  ∫ x, fourier k x ∂μ

/-- **Wiener's atom-detection formula** (§66). For a probability measure `μ` on
the circle `𝕋 = ℝ/2πℤ`, the Cesàro average of `|μ̂_k|²` for `k = 1, …, N`
converges to the sum of the squared masses of the atoms of `μ`. The right-hand
side is automatically summable: the atoms of a finite measure are at most
countable and their masses are bounded by `μ(𝕋) = 1`. -/
@[eval_problem]
theorem wiener_atom_detection
    (μ : Measure (AddCircle (2 * Real.pi))) [IsProbabilityMeasure μ] :
    Tendsto
      (fun N : ℕ =>
        (1 / (N : ℝ)) *
          ∑ k ∈ Finset.Icc (1 : ℤ) N, ‖fourierCoeffMeasure μ k‖ ^ 2)
      atTop
      (𝓝 (∑' x : AddCircle (2 * Real.pi), ((μ {x}).toReal) ^ 2)) := by
  sorry

end Analysis
end LeanEval
