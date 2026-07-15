import Mathlib.GroupTheory.CommutingProbability
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
Theorem 1.2 from Browning,
"Limit Points of Commuting Probabilities of Finite Groups" (`arXiv:2201.09402`).

Mathlib's definition of commuting probability is zero when the group is not finite,
so there is no need to add in `0` to make the set of commuting probabilities closed.
-/

/-- The set of commuting probabilities of finite groups is closed. -/
@[eval_problem]
theorem commProb_closed : IsClosed ({p : ℝ | ∃ (G : Type) (hG : Group G), commProb G = p}) := by
  sorry

end GroupTheory
end LeanEval
