import ChallengeDeps

open LeanEval.GroupTheory.NovikovUnsolvableProblem

theorem novikov_unsolvable :
    ∃ (n : ℕ) (rels : Set (FreeGroup (Fin n))),
      rels.Finite ∧ ¬ WordProblemSolvable (PresentedGroup.mk rels) := by
  sorry
