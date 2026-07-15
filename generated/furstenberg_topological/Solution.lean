import ChallengeDeps
import Submission

open LeanEval.Dynamics
open Filter Topology

theorem furstenberg_topological_recurrence {X : Type*} [MetricSpace X]
    [CompactSpace X] [Nonempty X] (T : X ≃ₜ X) :
    ∃ x : X, IsMultiplyRecurrent (T : X → X) x := by
  exact Submission.furstenberg_topological_recurrence T
