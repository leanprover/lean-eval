import ChallengeDeps
import Submission

open LeanEval.Geometry.SchlafliClassification
open scoped Topology

theorem schlafli_classification :
    platonicCount 3 = 5 ∧
      platonicCount 4 = 6 ∧
        ∀ d, 5 ≤ d → platonicCount d = 3 := by
  exact Submission.schlafli_classification
