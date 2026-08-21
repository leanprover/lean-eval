import ChallengeDeps
import Submission

open OnPropertyT

theorem theorem_1 (n : ℕ) (hn : n ≥ 6) : PropertyT (MulAut (FreeGroup (Fin n))) := by
  exact Submission.theorem_1 n hn
