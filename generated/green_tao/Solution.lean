import ChallengeDeps
import Submission

open LeanEval.NumberTheory

theorem green_tao : ContainsArbitraryAPs {p : ℕ | Nat.Prime p} := by
  exact Submission.green_tao
