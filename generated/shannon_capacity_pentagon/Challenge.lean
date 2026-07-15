import ChallengeDeps

open LeanEval.Combinatorics.ShannonCapacityPentagon
open Filter
open scoped Topology

theorem shannon_capacity_pentagon :
    HasShannonCapacity (SimpleGraph.cycleGraph 5) (Real.sqrt 5) := by
  sorry
