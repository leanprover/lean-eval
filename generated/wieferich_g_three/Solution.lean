import ChallengeDeps
import Submission

open LeanEval.NumberTheory

theorem wieferich_g_three :
    (∀ n : ℕ, IsSumOfCubes 9 n) ∧ ∃ n : ℕ, ¬ IsSumOfCubes 8 n := by
  exact Submission.wieferich_g_three
