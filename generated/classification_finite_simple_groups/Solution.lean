import TauCeti.GroupTheory.SpecificGroups.CFSG.Classification
import Submission

theorem classification_finite_simple_groups (G : Type) [Group G] [Finite G] [IsSimpleGroup G] :
    ∃ i : TauCeti.CFSGIndex, Nonempty (G ≃* i.Group) := by
  exact Submission.classification_finite_simple_groups G
