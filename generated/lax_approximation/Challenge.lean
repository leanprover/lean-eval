import ChallengeDeps

open LeanEval.Dynamics.LaxApproximation
open MeasureTheory
open scoped ENNReal

theorem lax_approximation {d : ℕ} (hd : 0 < d) (T : ToralDynamicalSystem d)
    {ε : ℝ≥0∞} (hε : 0 < ε) :
    ∃ (n : ℕ) (S : VolumePreservingEquiv d),
      IsCyclicCubeExchange S n ∧ deltaDist T.toVolumePreservingEquiv S < ε := by
  sorry
