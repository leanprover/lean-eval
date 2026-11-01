import Mathlib

open MeasureTheory

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]

theorem choquet [MeasurableSpace X] [BorelSpace X]
    (K : Set X) (hK_cpt : IsCompact K) (hK_cvx : Convex ℝ K)
    {x : X} (hx : x ∈ K) :
    ∃ μ : Measure X, IsProbabilityMeasure μ ∧
      μ (K.extremePoints ℝ)ᶜ = 0 ∧
      x = ∫ y, y ∂μ := by
  sorry
