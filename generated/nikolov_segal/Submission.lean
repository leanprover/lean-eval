import ChallengeDeps
import Submission.Helpers

open LeanEval.GroupTheory

namespace Submission

theorem nikolov_segal (G : Type*) [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
    [CompactSpace G] [TotallyDisconnectedSpace G]
    (hG : IsTopologicallyFinitelyGenerated G)
    (H : Subgroup G) [H.FiniteIndex] :
    IsOpen (H : Set G) := by
  sorry

end Submission
