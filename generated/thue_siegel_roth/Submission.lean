import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.ThueSiegelRothProblem
open Real

namespace Submission

theorem thueSiegelRoth (x : ℝ) (_h_irr : Irrational x)
    (_h_alg : IsAlgebraic ℤ x) : IsDiophantine x := by
  sorry

end Submission
