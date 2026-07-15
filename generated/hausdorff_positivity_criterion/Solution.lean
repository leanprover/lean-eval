import ChallengeDeps
import Submission

open LeanEval.Analysis
open MeasureTheory
open scoped BigOperators NNReal

theorem hausdorff_positivity {d : ℕ} (a : (Fin d → ℕ) → ℝ) :
    IsPositiveMomentConfiguration a ↔ ∀ k n : Fin d → ℕ, k ≤ n → 0 ≤ diff a k n := by
  exact Submission.hausdorff_positivity a
