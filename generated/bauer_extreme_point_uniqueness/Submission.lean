import Mathlib
import Submission.Helpers

open MeasureTheory

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]

namespace Submission

theorem bauer_unique [MeasurableSpace X] [BorelSpace X]
    (K : Set X) (hK_cpt : IsCompact K) (hK_cvx : Convex ℝ K)
    {x : X} (hx : x ∈ K.extremePoints ℝ)
    (μ : Measure X) [IsProbabilityMeasure μ]
    (hμ : μ Kᶜ = 0) (hbar : x = ∫ y, y ∂μ) :
    μ = Measure.dirac x := by
  sorry

end Submission
