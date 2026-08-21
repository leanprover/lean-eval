import Mathlib.Analysis.Fourier.AddCircle
import Mathlib.Analysis.Normed.Operator.Mul
import Mathlib.MeasureTheory.Measure.Complex
import Mathlib.MeasureTheory.VectorMeasure.Decomposition.RadonNikodym
import Mathlib.MeasureTheory.VectorMeasure.Integral
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

open MeasureTheory

theorem riesz_brothers_theorem (μ : ComplexMeasure UnitAddCircle)
    (hμ : ∀ n : ℕ, 1 ≤ n → ∫ᵛ z, fourier n z ∂[ContinuousLinearMap.mul ℝ ℂ; μ] = 0) :
    μ ≪ᵥ AddCircle.haarAddCircle.toENNRealVectorMeasure := by
  exact Submission.riesz_brothers_theorem μ hμ
