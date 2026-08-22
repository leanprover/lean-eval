import ChallengeDeps
import Submission

open UnitConjecture

set_option autoImplicit false

theorem theorem_A : (∀ g : P, ∀ n ≠ 0, g ^ n = 1 → g = 1) ∧ IsUnit u ∧ ¬ ∃ g : P, u = g := by
  exact Submission.theorem_A
