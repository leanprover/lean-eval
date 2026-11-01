import Mathlib
import Submission

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem normal_spectral_theorem (A : Matrix n n ℂ) :
    IsStarNormal A ↔
      ∃ U ∈ unitary (Matrix n n ℂ), ∃ d : n → ℂ,
        A = U * diagonal d * star U := by
  exact Submission.normal_spectral_theorem A
