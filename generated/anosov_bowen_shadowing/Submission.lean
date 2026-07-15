import ChallengeDeps
import Submission.Helpers

open LeanEval.Dynamics.HyperbolicShadowingProblem
open scoped Topology

variable {d : ℕ}

namespace Submission

theorem hyperbolic_has_shadowing (T : E d ≃ₜ E d) (K : Set (E d))
    (_hKc : IsCompact K) (_hK : IsHyperbolic T K) :
    HasShadowing (T : E d → E d) K := by
  sorry

end Submission
