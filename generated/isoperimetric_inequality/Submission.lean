import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry
open MeasureTheory ENNReal Metric

namespace Submission

theorem isoperimetric (n : ℕ) (_hn : 2 ≤ n) (B : Set (E n))
    (_hB : MeasurableSet B) (_hBdd : Bornology.IsBounded B) :
    (n : ℝ≥0∞) ^ n * (volume B) ^ (n - 1) * volume (closedBall (0 : E n) 1)
      ≤ (μHE[n - 1] (frontier B)) ^ n := by
  sorry

end Submission
