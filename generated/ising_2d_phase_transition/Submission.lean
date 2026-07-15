import ChallengeDeps
import Submission.Helpers

open LeanEval.Analysis.IsingPhaseTransition
open Filter
open scoped BigOperators Topology

namespace Submission

theorem ising_2d_phase_transition :
    ∃ (F : ℝ → ℝ) (βc : ℝ),
      0 < βc ∧
        (∀ β : ℝ,
          Tendsto (fun n : ℕ => finiteIsingFreeEnergySeq n β) atTop (𝓝 (F β))) ∧
        ¬ AnalyticAt ℝ F βc := by
  sorry

end Submission
