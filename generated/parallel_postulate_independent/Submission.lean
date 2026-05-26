import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry

namespace Submission

theorem parallel_postulate_independent :
    (∃ (M : Type) (T : TarskiAbsolute M), Euclidean M T) ∧
    (∃ (M : Type) (T : TarskiAbsolute M), ¬ Euclidean M T) := by
  sorry

end Submission
