import ChallengeDeps
import Submission

open OnCoherenceOfOneRelatorGroups

theorem theorem_1_1 (G K : Type*) [Group G] [Field K] [CharZero K] (hG : Group.OneRelator G) :
    Group.Coherent G ∧ Ring.Coherent (MonoidAlgebra K G) := by
  exact Submission.theorem_1_1 G K hG
