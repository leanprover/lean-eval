import Mathlib.GroupTheory.CommutingProbability
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
Theorem 1.2 from Browning,
"Limit Points of Commuting Probabilities of Finite Groups" (`arXiv:2201.09402`).
-/

/-- The set of commuting probabilities of finite groups is closed. -/
@[eval_problem]
theorem commProb_closed :
    IsClosed ({p : ℝ | ∃ (G : Type) (_ : Group G), commProb G = p} ∪ {0}) := by
  sorry

end GroupTheory
end LeanEval
