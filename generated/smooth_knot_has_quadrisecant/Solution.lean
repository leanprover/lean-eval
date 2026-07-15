import ChallengeDeps
import Submission

open LeanEval.KnotTheory.Quadrisecant

theorem smooth_knot_has_quadrisecant {r : ℝ → Space} (_hknot : IsSmoothKnot r) (_hnontrivial : ¬ IsUnknotted r) :
    HasQuadrisecant r := by
  exact Submission.smooth_knot_has_quadrisecant _hknot _hnontrivial
