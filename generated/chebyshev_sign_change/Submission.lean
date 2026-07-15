import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.ChebyshevSignChangeProblem
open Filter

namespace Submission

theorem chebyshev_sign_change :
    chebyshevLead.Infinite ∧
    {n : ℕ | primeCountingMod 3 n < primeCountingMod 1 n}.Infinite := by
  sorry

end Submission
