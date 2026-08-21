import ChallengeDeps
import Submission.Helpers

open WilkiesConjecture
open FirstOrder Language IntermediateField

variable {n : ℕ}
local notation "ℝⁿ" => Fin n → ℝ

namespace Submission

theorem corollary_1 (X : Set ℝⁿ) (h : IsRExpDefinable X) :
    ∃ f : MvPolynomial (Fin 2) ℝ, ∀ (g H : ℕ),
      Nat.card (degreeHeightLE X.trans g H) ≤ f.eval ![(g : ℝ), Real.log H] := by
  sorry

end Submission
