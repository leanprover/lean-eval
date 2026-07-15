import ChallengeDeps
import Submission

open LeanEval.Combinatorics.ShannonCapacityPentagon
open Filter
open scoped Topology

theorem shannon_capacity_pentagon :
    HasShannonCapacity (SimpleGraph.cycleGraph 5) (Real.sqrt 5) := by
  exact Submission.shannon_capacity_pentagon
