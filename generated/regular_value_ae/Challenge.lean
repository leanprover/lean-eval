import ChallengeDeps

open LeanEval.Geometry.RegularValue
open MeasureTheory
open scoped ContDiff

theorem regular_value_ae {m : ℕ} (f : EuclideanSpace ℝ (Fin m) → ℝ)
    (hf : ContDiff ℝ ∞ f) :
    ∀ᵐ c ∂(volume : Measure ℝ), IsRegularValue f c := by
  sorry
