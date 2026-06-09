import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis
open MeasureTheory
open scoped BigOperators NNReal

namespace Submission

theorem hausdorff_positivity {d : ℕ} (a : (Fin d → ℕ) → ℝ) :
    IsPositiveMomentConfiguration a ↔ ∀ k n : Fin d → ℕ, k ≤ n → 0 ≤ diff a k n := by
  sorry

end Submission
