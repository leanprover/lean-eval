import ChallengeDeps

open LeanEval.Topology
open Matrix

theorem nonlinear_three_manifold_group :
    ∃ (M : Closed3Manifold) (x : M.carrier),
      ∀ f : FundamentalGroup M.carrier x →* GL (Fin 4) ℝ, ¬ Function.Injective f := by
  sorry
