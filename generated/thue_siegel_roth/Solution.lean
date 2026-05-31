import ChallengeDeps
import Submission

open LeanEval.NumberTheory.ThueSiegelRothProblem
open Real

theorem thueSiegelRoth (x : ℝ) (_h_irr : Irrational x)
    (_h_alg : IsAlgebraic ℤ x) : IsDiophantine x := by
  exact Submission.thueSiegelRoth x _h_irr _h_alg
