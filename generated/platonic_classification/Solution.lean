import ChallengeDeps
import Submission

open LeanEval.Geometry.PlatonicClassification
open scoped Topology

theorem platonic_classification :
    platonicCount 2 = ⊤ ∧
      platonicCount 3 = 5 ∧
        platonicCount 4 = 6 ∧
          ∀ d, 5 ≤ d → platonicCount d = 3 := by
  exact Submission.platonic_classification
