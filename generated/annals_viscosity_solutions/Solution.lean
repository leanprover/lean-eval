import ChallengeDeps
import Submission

open ViscositySolutions
open Filter Gradient Real Set

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [FiniteDimensional ℝ E]
variable {N : ℕ}
local notation "ℝᴺ" => Fin N → ℝ
local notation "Eᴺ" => EuclideanSpace E (Fin N)

theorem theorem_1_1 (hE : 2 ≤ Module.finrank ℝ E) (m : ℝᴺ) (hm : ∀ i, 0 < m i)
    (x₀ a : Eᴺ) (a_nc : WithoutCollisions a) (a_norm : ‖a‖_[m] = 1) (h : ℝ) (h_pos : h > 0) :
    ∃ x : ℝ → Eᴺ, ∃ o : ℝ → Eᴺ, (o =o[atTop] fun t ↦ t) ∧ x 0 = x₀ ∧
      IsNBodySolution m x ∧ (∀ t > 0, WithoutCollisions (x t)) ∧
        ∀ t ≥ 0, x t = (sqrt (2 * h) * t) • a + o t := by
  exact Submission.theorem_1_1 hE m hm x₀ a a_nc a_norm h h_pos
