import Mathlib.GroupTheory.CommutingProbability
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

namespace Submission

theorem commProb_closed : IsClosed ({p : ℝ | ∃ (G : Type) (hG : Group G), commProb G = p}) := by
  sorry

end Submission
