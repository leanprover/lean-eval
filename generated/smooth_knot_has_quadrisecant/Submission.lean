import ChallengeDeps
import Submission.Helpers

open LeanEval.KnotTheory.Quadrisecant

namespace Submission

theorem smooth_knot_has_quadrisecant {r : ℝ → Space} (_hknot : IsSmoothKnot r) (_hnontrivial : ¬ IsUnknotted r) :
    HasQuadrisecant r := by
  sorry

end Submission
