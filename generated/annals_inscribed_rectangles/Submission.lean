import ChallengeDeps
import Submission.Helpers

open InscribedRectangles
open Manifold Real MeasureTheory
open scoped ContDiff

namespace Submission

theorem theorem_1 (γ : Circle → ℝ × ℝ) (hγ : IsSmoothEmbedding (𝓡 1) 𝓘(ℝ, ℝ × ℝ) ∞ γ) :
    volume (X γ) ≥ 1/3 := by
  sorry

end Submission
