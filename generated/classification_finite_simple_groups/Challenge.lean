import TauCeti.GroupTheory.SpecificGroups.CFSG.Classification

theorem classification_finite_simple_groups (G : Type) [Group G] [Finite G] [IsSimpleGroup G] :
    ∃ i : TauCeti.CFSGIndex, Nonempty (G ≃* i.Group) := by
  sorry
