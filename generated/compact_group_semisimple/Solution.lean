import Mathlib
import Submission

open Representation

theorem compact_group_semisimple {G V : Type*} [Group G] [TopologicalSpace G] [IsTopologicalGroup G] [CompactSpace G]
    [NormedAddCommGroup V] [NormedSpace ℝ V] [FiniteDimensional ℝ V]
    (ρ : Representation ℝ G V)
    (hρ : Continuous fun p : G × V => ρ p.1 p.2) :
    ρ.IsSemisimpleRepresentation := by
  exact Submission.compact_group_semisimple ρ hρ
