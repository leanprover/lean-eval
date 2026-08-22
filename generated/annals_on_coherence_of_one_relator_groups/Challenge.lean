import ChallengeDeps

open OnCoherenceOfOneRelatorGroups

set_option autoImplicit false

theorem theorem_1_1 (G K : Type*) [Group G] [Field K] [CharZero K] (hG : Group.OneRelator G) :
    Group.Coherent G ∧ Ring.Coherent (MonoidAlgebra K G) := by
  sorry
