import ChallengeDeps
import Submission.Helpers

open LeanEval.Dynamics
open Filter Topology

namespace Submission

theorem furstenberg_topological_recurrence {X : Type*} [MetricSpace X]
    [CompactSpace X] [Nonempty X] (T : X ≃ₜ X) :
    ∃ x : X, IsMultiplyRecurrent (T : X → X) x := by
  sorry

end Submission
