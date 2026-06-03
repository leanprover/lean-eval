import ChallengeDeps
import Submission

open LeanEval.Geometry.FaryMilnorProblem
open Set
open scoped Real
open WithLp

theorem fary_milnor_total_curvature {r : ℝ → Space} (_hknot : IsSmoothKnot r)
    (_hK : totalCurvature r ≤ 4 * Real.pi) :
    IsUnknotted r := by
  exact Submission.fary_milnor_total_curvature _hknot _hK
