import ChallengeDeps
import Submission

open LeanEval.Geometry.RegularValue
open MeasureTheory
open scoped ContDiff

theorem regular_value_ae {m : ℕ} (f : EuclideanSpace ℝ (Fin m) → ℝ)
    (hf : ContDiff ℝ ∞ f) :
    ∀ᵐ c ∂(volume : Measure ℝ), IsRegularValue f c := by
  exact Submission.regular_value_ae f hf
