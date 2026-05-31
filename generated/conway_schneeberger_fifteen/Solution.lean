import ChallengeDeps
import Submission

open LeanEval.NumberTheory.ConwaySchneebergerFifteenProblem

theorem conway_schneeberger_fifteen {n : ℕ}
    (Q : Matrix (Fin n) (Fin n) ℤ)
    (_hsymm : Q.IsSymm) (_hpos : IsPositiveQ Q) :
    IsUniversal Q ↔ ∀ k ∈ Finset.Icc (1 : ℤ) 15, Represents Q k := by
  exact Submission.conway_schneeberger_fifteen Q _hsymm _hpos
