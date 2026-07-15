import ChallengeDeps
import Submission

open LeanEval.ComplexAnalysis
open Function

theorem mandelbar_not_path_connected : ¬ IsPathConnected Mandelbar := by
  exact Submission.mandelbar_not_path_connected
