import ChallengeDeps
import Submission

open LeanEval.Geometry.HopfUmlaufsatz

theorem hopf_umlaufsatz {r : ℝ → Plane} {α : ℝ → ℝ}
    (_hr : IsPositiveSimpleClosedUnitSpeedCurve r)
    (_hα : IsTangentAngleLift r α) :
    totalCurvature α = 2 * Real.pi := by
  exact Submission.hopf_umlaufsatz _hr _hα
