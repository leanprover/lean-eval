import ChallengeDeps
import Submission.Helpers

open McKayConjecture
open CategoryTheory Module Subgroup

variable (ℓ : ℕ) (X : Type*) [Group X] [Finite X]

namespace Submission

theorem theorem_1_1 (hℓ : ℓ.Prime) (S : Sylow ℓ X) :
    (Irr' ℓ X).ncard = (Irr' ℓ (normalizer S : Subgroup X)).ncard := by
  sorry

end Submission
