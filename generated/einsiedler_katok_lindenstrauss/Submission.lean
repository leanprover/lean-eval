import ChallengeDeps
import Submission.Helpers

open LeanEval.Dynamics.EinsiedlerKatokLindenstrauss

namespace Submission

theorem einsiedler_katok_lindenstrauss :
    dimH {(α, β) : ℝ × ℝ | Filter.atTop.liminf
      (fun n : ℕ ↦ n * distToNearestInt (n * α) * distToNearestInt (n * β)) > 0} = 0 := by
  sorry

end Submission
