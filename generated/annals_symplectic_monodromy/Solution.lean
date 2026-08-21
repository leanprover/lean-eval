import ChallengeDeps
import Submission

open SymplecticMonodromy
open MvPowerSeries

theorem theorem_1_1 (n : ℕ) (f : unitInterval → MvPowerSeries (Fin n) ℂ)
    (cont : ∀ d, Continuous fun t ↦ coeff d (f t)) (h_const : ∀ t, constantCoeff (f t) = 0)
    (h : ∃ μ : ℕ, ∀ t, milnorNumber (f t) = μ) : ∀ t₁ t₂, (f t₁).order = (f t₂).order := by
  exact Submission.theorem_1_1 n f cont h_const h
