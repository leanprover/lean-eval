import ChallengeDeps

open GoodLTC
open NNReal

variable (n : ℕ)
local notation "𝔽₂ⁿ" => Fin n → ZMod 2
variable {n} (C : BinaryCode n)

theorem theorem_1_2 (ρ : ℝ≥0) (hρ : ρ < 1) :
    ∃ q, ∃ κ ≠ 0, ∃ (n : ℕ → ℕ), ∃ (𝒞 : (i : ℕ) → BinaryCode (n i)), IsGood 𝒞 ∧
      ∀ i, Nonempty (LTC q κ (𝒞 i)) ∧ rate (𝒞 i) ≥ ρ := by
  sorry
