import ChallengeDeps
import Submission

open LeanEval.Analysis.IsingPhaseTransition
open Filter
open scoped BigOperators Topology

theorem ising_2d_phase_transition :
    ∃ (F : ℝ → ℝ) (βc : ℝ),
      0 < βc ∧
        (∀ β : ℝ,
          Tendsto (fun n : ℕ => finiteIsingFreeEnergySeq n β) atTop (𝓝 (F β))) ∧
        ¬ AnalyticAt ℝ F βc := by
  exact Submission.ising_2d_phase_transition
