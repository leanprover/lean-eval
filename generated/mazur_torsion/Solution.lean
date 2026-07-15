import ChallengeDeps
import Submission

open LeanEval.NumberTheory.MazurTorsion
open scoped WeierstrassCurve

theorem mazur_torsion (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    IsInMazurClass ↥(AddCommGroup.torsion (WeierstrassCurve.Affine.Point E)) := by
  exact Submission.mazur_torsion E
