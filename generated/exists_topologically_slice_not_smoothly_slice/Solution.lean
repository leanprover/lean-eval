import ChallengeDeps
import Submission

open LeanEval.KnotTheory

theorem exists_topologically_slice_not_smoothly_slice :
    ∃ K : PLKnot, K.TopologicallySlice ∧ ¬ K.SmoothlySlice := by
  exact Submission.exists_topologically_slice_not_smoothly_slice
