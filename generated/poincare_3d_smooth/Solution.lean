import Mathlib
import Submission

open scoped Manifold ContDiff
open Metric (sphere)

theorem poincare_3d_smooth {M : Type*} [TopologicalSpace M] [T2Space M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M] [IsManifold (𝓡 3) ∞ M]
    [SimplyConnectedSpace M] [CompactSpace M] :
    Nonempty (M ≃ₘ⟮𝓡 3, 𝓡 3⟯ sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) := by
  exact Submission.poincare_3d_smooth
