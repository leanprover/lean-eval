import ChallengeDeps

open LeanEval.Geometry.FaryMilnorProblem
open Set
open scoped Real
open WithLp

theorem fary_milnor_total_curvature {r : ℝ → Space} (_hknot : IsSmoothKnot r)
    (_hK : totalCurvature r ≤ 4 * Real.pi) :
    IsUnknotted r := by
  sorry
