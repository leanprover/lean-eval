import ChallengeDeps
import Submission

open LeanEval.Dynamics.EinsiedlerKatokLindenstrauss

theorem einsiedler_katok_lindenstrauss :
    dimH {(α, β) : ℝ × ℝ | Filter.atTop.liminf
      (fun n : ℕ ↦ n * distToNearestInt (n * α) * distToNearestInt (n * β)) > 0} = 0 := by
  exact Submission.einsiedler_katok_lindenstrauss
