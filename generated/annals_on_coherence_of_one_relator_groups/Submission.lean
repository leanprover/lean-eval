import ChallengeDeps
import Submission.Helpers

open OnCoherenceOfOneRelatorGroups

namespace Submission

theorem theorem_1_1 (G K : Type*) [Group G] [Field K] [CharZero K] (hG : Group.OneRelator G) :
    Group.Coherent G ∧ Ring.Coherent (MonoidAlgebra K G) := by
  sorry

end Submission
