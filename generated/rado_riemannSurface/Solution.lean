import Mathlib.Analysis.Complex.Basic
import Mathlib.Geometry.Manifold.IsManifold.Basic
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem rado_riemannSurface {X : Type*} [TopologicalSpace X] [T2Space X] [ConnectedSpace X]
    [ChartedSpace ℂ X] [IsManifold (modelWithCornersSelf ℂ ℂ) 1 X] :
    SecondCountableTopology X := by
  exact Submission.rado_riemannSurface
