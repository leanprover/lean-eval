import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.PicksTheorem
open MeasureTheory

namespace Submission

theorem pick {n : ℕ} (hn : 3 ≤ n) (v : Fin n → ℤ × ℤ)
    (hsimple : IsSimple (latPoly v)) :
    area ((latPoly v).boundary (R := ℝ))
      = (interiorPts v : ℝ) + (boundaryPts v : ℝ) / 2 - 1 := by
  sorry

end Submission
