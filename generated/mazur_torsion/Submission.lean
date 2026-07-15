import ChallengeDeps
import Submission.Helpers

open LeanEval.NumberTheory.MazurTorsion
open scoped WeierstrassCurve

namespace Submission

theorem mazur_torsion (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    IsInMazurClass ↥(AddCommGroup.torsion (WeierstrassCurve.Affine.Point E)) := by
  sorry

end Submission
