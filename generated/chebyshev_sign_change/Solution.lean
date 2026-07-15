import ChallengeDeps
import Submission

open LeanEval.NumberTheory.ChebyshevSignChangeProblem
open Filter

theorem chebyshev_sign_change :
    chebyshevLead.Infinite ∧
    {n : ℕ | primeCountingMod 3 n < primeCountingMod 1 n}.Infinite := by
  exact Submission.chebyshev_sign_change
