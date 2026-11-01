import Mathlib
import Submission.Helpers

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

namespace Submission

theorem normal_spectral_theorem (A : Matrix n n ℂ) :
    IsStarNormal A ↔
      ∃ U ∈ unitary (Matrix n n ℂ), ∃ d : n → ℂ,
        A = U * diagonal d * star U := by
  sorry

end Submission
