import Mathlib.GroupTheory.CommutingProbability
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import Lake.Toml
import Lake.Util.Message
import Lean

theorem commProb_closed : IsClosed ({p : ℝ | ∃ (G : Type) (hG : Group G), commProb G = p}) := by
  sorry
