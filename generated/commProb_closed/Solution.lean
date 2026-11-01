import Mathlib.GroupTheory.CommutingProbability
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import Submission

theorem commProb_closed : IsClosed ({p : ℝ | ∃ (G : Type) (_hG : Group G), commProb G = p}) := by
  exact Submission.commProb_closed
