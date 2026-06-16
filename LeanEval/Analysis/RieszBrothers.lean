import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.Normed.Operator.Mul
import Mathlib.MeasureTheory.Measure.Complex
import Mathlib.MeasureTheory.VectorMeasure.Decomposition.RadonNikodym
import Mathlib.MeasureTheory.VectorMeasure.Integral
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# F. and M. Riesz brothers theorem

The F. and M. Riesz theorem says that a complex Borel measure on the circle
whose positive analytic moments vanish is absolutely continuous with respect to
Haar measure, and its Radon-Nikodym density belongs to the Hardy space `H^1`.

We use the additive circle `AddCircle 1` as the unit circle. The condition
`complexMoment μ n = 0` is the vector-measure version of
`∫ z^n dμ = 0`; the conclusion is expressed by writing the complex measure as
`m.withDensityᵥ h`, where `m` is normalized Haar measure and `h` has vanishing
negative Fourier coefficients.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

local instance : Fact (0 < (1 : ℝ)) := ⟨zero_lt_one⟩

/-- The unit circle, represented as `R/Z`. -/
abbrev HardyCircle : Type :=
  AddCircle (1 : ℝ)

/-- A complex-valued Borel measure on the unit circle. -/
abbrev CircleComplexMeasure : Type :=
  ComplexMeasure HardyCircle

/-- The normalized Haar probability measure on the unit circle. -/
abbrev circleHaar : Measure HardyCircle :=
  AddCircle.haarAddCircle

/-- The pairing used to integrate complex-valued functions against complex measures. -/
abbrev complexMulPairing : ℂ →L[ℝ] ℂ →L[ℝ] ℂ :=
  ContinuousLinearMap.mul ℝ ℂ

/-- The `n`-th analytic moment of a complex measure on the circle:
`∫ z^n dμ`, written using mathlib's Fourier monomial `fourier n`. -/
noncomputable def complexMoment (μ : CircleComplexMeasure) (n : ℤ) : ℂ :=
  ∫ᵛ z, fourier n z ∂[complexMulPairing; μ]

/-- The boundary Hardy space `H^1` condition for a density on the unit circle:
it is integrable and all negative Fourier coefficients vanish. -/
def HasHardyH1Density (h : HardyCircle → ℂ) : Prop :=
  Integrable h circleHaar ∧ ∀ k : ℤ, k < 0 → fourierCoeff (T := (1 : ℝ)) h k = 0

/-- **F. and M. Riesz brothers theorem.** Let `μ` be a complex Borel measure on
the unit circle such that `∫ z^n dμ = 0` for every `n ≥ 1`. Then `μ` is
absolutely continuous with respect to Haar measure, and more precisely
`dμ = h dm` for some `h ∈ H^1`, i.e. some integrable density whose negative
Fourier coefficients vanish. -/
@[eval_problem]
theorem riesz_brothers_theorem
    (μ : CircleComplexMeasure)
    (hμ : ∀ n : ℕ, 1 ≤ n → complexMoment μ (n : ℤ) = 0) :
    ∃ h : HardyCircle → ℂ, HasHardyH1Density h ∧ circleHaar.withDensityᵥ h = μ := by
  sorry

end

end Analysis
end LeanEval
