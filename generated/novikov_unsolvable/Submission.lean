import ChallengeDeps
import Submission.Helpers

open LeanEval.GroupTheory.NovikovUnsolvableProblem

namespace Submission

theorem novikov_unsolvable :
    ∃ (n : ℕ) (rels : Set (FreeGroup (Fin n))),
      rels.Finite ∧ ¬ WordProblemSolvable (PresentedGroup.mk rels) := by
  sorry

end Submission
