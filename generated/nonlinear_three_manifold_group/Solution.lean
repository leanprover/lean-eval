import ChallengeDeps
import Submission

open LeanEval.Topology
open Matrix

theorem nonlinear_three_manifold_group :
    ∃ (M : Closed3Manifold) (x : M.carrier),
      ∀ f : FundamentalGroup M.carrier x →* GL (Fin 4) ℝ, ¬ Function.Injective f := by
  exact Submission.nonlinear_three_manifold_group
