import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.ChenTheorem
open Filter Finset MeasureTheory
open scoped BigOperators Topology

namespace Submission

theorem chen_theorem :
    {p : ℕ | p.Prime ∧ HasAtMostTwoPrimeFactors (p + 2)}.Infinite := by
  sorry

end Submission
