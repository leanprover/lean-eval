import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.HopfUmlaufsatz

namespace Submission

theorem hopf_umlaufsatz {r : ℝ → Plane} {α : ℝ → ℝ}
    (_hr : IsPositiveSimpleClosedUnitSpeedCurve r)
    (_hα : IsTangentAngleLift r α) :
    totalCurvature α = 2 * Real.pi := by
  sorry

end Submission
