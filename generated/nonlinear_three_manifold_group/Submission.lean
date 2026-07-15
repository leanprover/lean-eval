import ChallengeDeps
import Submission.Helpers

open LeanEval.Topology
open Matrix

namespace Submission

theorem nonlinear_three_manifold_group :
    ∃ (M : Closed3Manifold) (x : M.carrier),
      ∀ f : FundamentalGroup M.carrier x →* GL (Fin 4) ℝ, ¬ Function.Injective f := by
  sorry

end Submission
