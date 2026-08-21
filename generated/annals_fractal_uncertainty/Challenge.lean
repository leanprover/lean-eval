import ChallengeDeps

open FractalUncertainty
open MeasureTheory FourierTransform Metric
open scoped ENNReal

variable {d : ℕ}
local notation "ℝᵈ" => EuclideanSpace ℝ (Fin d)

theorem theorem_1_1 (ν : ℝ) (hν₀ : 0 < ν) :
    ∃ (β C : ℝ), β > 0 ∧ C > 0 ∧ ∀ (h : ℝ) (X Y : Set ℝᵈ)
      (hX : MeasurableSet X) (hY : MeasurableSet Y), h ∈ Set.Ioo 0 (1 / 100) →
        X ⊆ cube (-1) 1 → PorousOnBalls ν h 1 X → Y ⊆ cube (-h⁻¹) h⁻¹ →
          PorousOnLines ν 1 h⁻¹ Y → ∀ (f : Lp ℂ 2), (𝓕 f : Lp ℂ 2) =ᵐ[volume.restrict Yᶜ] 0 →
            (eLpNorm (X.indicator f) 2).toReal ≤ C * h ^ β * ‖f‖ := by
  sorry
