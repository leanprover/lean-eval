import Mathlib.Algebra.Group.Action.Faithful
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Geometry.Manifold.ChartedSpace
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.Topology.Algebra.MulAction
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

namespace Submission

theorem hilbert_smith_padic_dimension_three (p : ℕ) [Fact p.Prime]
    (M : Type*) [TopologicalSpace M] [T2Space M] [SecondCountableTopology M]
    [ConnectedSpace M] [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [AddAction (PadicInt p) M] [ContinuousVAdd (PadicInt p) M]
    [FaithfulVAdd (PadicInt p) M] :
    False := by
  sorry

end Submission
