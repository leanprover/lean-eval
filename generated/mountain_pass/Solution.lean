import ChallengeDeps
import Submission

open LeanEval.Analysis.MountainPassProblem
open scoped unitInterval

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

theorem mountain_pass (f : E → ℝ) (_hf : ContDiff ℝ 1 f) (_hps : PalaisSmale f)
    {a b : E} {ε r : ℝ} (_hmr : MountainRange f a b ε r) :
    ∃ x : E, IsCriticalPoint f x ∧
      f x = mountainPassLevel f a b ∧ ε ≤ mountainPassLevel f a b := by
  exact Submission.mountain_pass f _hf _hps _hmr
