import ChallengeDeps
import Submission

open LeanEval.Geometry
open scoped Manifold ContDiff

theorem uniformization {X : Type*} [TopologicalSpace X] [T2Space X] [ConnectedSpace X]
    [SecondCountableTopology X] [ChartedSpace ℂ X] [IsManifold mℂ 1 X]
    (hX : ¬ CompactSpace X) (x : X) [Subsingleton <| Additive (FundamentalGroup X x) →+ ℝ] :
    Nonempty (X ≃ₘ⟮mℂ, mℂ⟯ ℂ) ∨ Nonempty (X ≃ₘ⟮mℂ, mℂ⟯ UpperHalfPlane) := by
  exact Submission.uniformization hX x
