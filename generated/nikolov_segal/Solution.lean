import ChallengeDeps
import Submission

open LeanEval.GroupTheory

theorem nikolov_segal (G : Type*) [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
    [CompactSpace G] [TotallyDisconnectedSpace G]
    (hG : IsTopologicallyFinitelyGenerated G)
    (H : Subgroup G) [H.FiniteIndex] :
    IsOpen (H : Set G) := by
  exact Submission.nikolov_segal G hG H
