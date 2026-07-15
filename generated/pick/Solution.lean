import ChallengeDeps
import Submission

open LeanEval.Geometry.PicksTheorem
open MeasureTheory

theorem pick {n : ℕ} (hn : 3 ≤ n) (v : Fin n → ℤ × ℤ)
    (hsimple : IsSimple (latPoly v)) :
    area ((latPoly v).boundary (R := ℝ))
      = (interiorPts v : ℝ) + (boundaryPts v : ℝ) / 2 - 1 := by
  exact Submission.pick hn v hsimple
