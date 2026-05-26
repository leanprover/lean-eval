import ChallengeDeps
import Submission

open LeanEval.ConvexGeometry
open scoped Classical

theorem hadwiger (n : ℕ) : Module.finrank ℝ (valuations n) = n + 1 := by
  exact Submission.hadwiger n
