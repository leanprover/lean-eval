import ChallengeDeps
import Submission.Helpers

open LeanEval.Geometry.SchlafliClassification
open scoped Topology

namespace Submission

theorem schlafli_classification :
    platonicCount 3 = 5 ∧
      platonicCount 4 = 6 ∧
        ∀ d, 5 ≤ d → platonicCount d = 3 := by
  sorry

end Submission
