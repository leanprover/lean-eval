import Mathlib
import Submission

theorem schoenflies (r : Metric.sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 → EuclideanSpace ℝ (Fin 2))
    (_hcont : Continuous r) (_hinj : Function.Injective r) :
    ∃ h : EuclideanSpace ℝ (Fin 2) ≃ₜ EuclideanSpace ℝ (Fin 2),
      h '' Set.range r = Metric.sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 := by
  exact Submission.schoenflies r _hcont _hinj
