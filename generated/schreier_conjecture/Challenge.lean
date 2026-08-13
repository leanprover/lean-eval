import ChallengeDeps

open LeanEval.GroupTheory

theorem schreier_conjecture (S : Type) [Group S] [Fintype S] [IsSimpleGroup S] :
    IsSolvable (MulAut S ⧸ (MulAut.conj : S →* MulAut S).range) := by
  sorry
