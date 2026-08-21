import ChallengeDeps
import Submission

open InscribedRectangles
open Manifold Real MeasureTheory
open scoped ContDiff

theorem theorem_1 (γ : Circle → ℝ × ℝ) (hγ : IsSmoothEmbedding (𝓡 1) 𝓘(ℝ, ℝ × ℝ) ∞ γ) :
    volume (X γ) ≥ 1/3 := by
  exact Submission.theorem_1 γ hγ
