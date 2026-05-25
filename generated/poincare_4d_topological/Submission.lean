import Mathlib
import Submission.Helpers

open Metric (sphere)
open ContinuousMap

namespace Submission

theorem poincare_4d_topological {M : Type*} [TopologicalSpace M] [T2Space M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M]
    (_h : M ≃ₕ sphere (0 : EuclideanSpace ℝ (Fin 5)) 1) :
    Nonempty (M ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin 5)) 1) := by
  sorry

end Submission
