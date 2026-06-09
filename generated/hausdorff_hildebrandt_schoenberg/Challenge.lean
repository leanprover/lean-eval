import ChallengeDeps

open LeanEval.Analysis
open MeasureTheory
open scoped BigOperators NNReal

theorem hausdorff_hildebrandt_schoenberg {d : ℕ} (a : (Fin d → ℕ) → ℝ) :
    IsMomentConfiguration a ↔ HausdorffBounded a := by
  sorry
