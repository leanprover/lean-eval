import ChallengeDeps
import Submission

open LeanEval.Geometry.SpaceGroupsProblem

theorem space_groups :
    crystallographicCountOP 3 = 230 ∧
      crystallographicCount 3 = 219 ∧
        crystallographicCountOPOnly 3 = 65 := by
  exact Submission.space_groups
