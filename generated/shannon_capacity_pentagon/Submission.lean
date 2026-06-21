import ChallengeDeps
import Submission.Helpers

open LeanEval.Combinatorics.ShannonCapacityPentagon
open Filter
open scoped Topology

namespace Submission

theorem shannon_capacity_pentagon :
    HasShannonCapacity (SimpleGraph.cycleGraph 5) (Real.sqrt 5) := by
  sorry

end Submission
