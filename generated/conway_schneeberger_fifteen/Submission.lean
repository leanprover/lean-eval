import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.ConwaySchneebergerFifteenProblem

namespace Submission

theorem conway_schneeberger_fifteen {n : ℕ}
    (Q : Matrix (Fin n) (Fin n) ℤ)
    (_hsymm : Q.IsSymm) (_hpos : IsPositiveQ Q) :
    IsUniversal Q ↔ ∀ k ∈ Finset.Icc (1 : ℤ) 15, Represents Q k := by
  sorry

end Submission
