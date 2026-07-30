import Mathlib.Algebra.Group.Action.Faithful
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Geometry.Manifold.ChartedSpace
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.Topology.Algebra.MulAction
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# No continuous faithful ℤ_p action on a connected 3-manifold (Pardon 2013)

John Pardon proved that the additive group of `p`-adic integers cannot act
continuously and faithfully on a connected three-dimensional topological
manifold. By the standard reduction of Hilbert–Smith to `p`-adic actions, this
establishes the Hilbert–Smith conjecture in dimension three.

The statement below is Pardon’s Theorem 1.5. The manifold is represented by a
Hausdorff, second-countable charted space modelled on `ℝ³`; no differentiable
structure is assumed.
-/

/-- **No continuous faithful `ℤ_p` action on a connected 3-manifold** (Pardon
2013, Theorem 1.5). The additive group of `p`-adic integers cannot act
continuously and faithfully on a connected topological three-manifold.

This is the `p`-adic step, not the full Hilbert–Smith conjecture: deducing that
every locally compact group acting faithfully on a connected three-manifold is
a Lie group additionally requires the classical reduction to `ℤ_p` actions,
which is not part of this statement. -/
@[eval_problem]
theorem hilbert_smith_padic_dimension_three
    (p : ℕ) [Fact p.Prime]
    (M : Type*) [TopologicalSpace M] [T2Space M] [SecondCountableTopology M]
    [ConnectedSpace M] [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [AddAction (PadicInt p) M] [ContinuousVAdd (PadicInt p) M]
    [FaithfulVAdd (PadicInt p) M] :
    False := by
  sorry

end Topology
end LeanEval
