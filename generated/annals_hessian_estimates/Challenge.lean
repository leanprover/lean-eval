import ChallengeDeps

open HessianEstimates
open Laplacian Metric ContDiff MeasureTheory ENNReal

local notation "‖" f "‖_C¹(" s ")" => eC1NormOn f s volume
local notation "‖" T "‖_F" => frobeniusNorm T
local notation "ℝ⁴" => EuclideanSpace ℝ (Fin 4)
local notation "B₁(0)" => ball 0 1

theorem theorem_1_1 : ∃ C : ℝ≥0∞ → ℝ, ∀ (u : ℝ⁴ → ℝ)
    (_smooth : ContDiffOn ℝ ∞ u B₁(0))
    (_bounded : ‖u‖_C¹(B₁(0)) < (∞ : ℝ≥0∞))
    (_positive_branch : ∀ x ∈ B₁(0), (Δ u) x > 0)
    (_solution : ∀ x ∈ B₁(0), σ₂ (H u B₁(0) x) = 1),
    ‖H u B₁(0) 0‖_F ≤ C (‖u‖_C¹(B₁(0))) := by
  sorry
