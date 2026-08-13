import ChallengeDeps
import Submission

open LeanEval.NumberTheory.TwoNinety
open Matrix

variable {R : Type*} [Ring R] {n : ℕ}

theorem two_ninety_theorem {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ)
    (hpos : M.PosDef)
    (hIntegral : Integral M)
    (hrep : ∀ m ∈ criticalNumbers, Represents M m) :
    IsUniversal M := by
  exact Submission.two_ninety_theorem M hpos hIntegral hrep
