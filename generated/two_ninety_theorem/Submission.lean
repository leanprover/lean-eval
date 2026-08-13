import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.TwoNinety
open Matrix

variable {R : Type*} [Ring R] {n : ℕ}

namespace Submission

theorem two_ninety_theorem {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ)
    (hpos : M.PosDef)
    (hIntegral : Integral M)
    (hrep : ∀ m ∈ criticalNumbers, Represents M m) :
    IsUniversal M := by
  sorry

end Submission
