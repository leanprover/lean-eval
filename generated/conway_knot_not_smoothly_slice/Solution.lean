import ChallengeDeps
import Submission

open LeanEval.KnotTheory

theorem conway_knot_not_smoothly_slice : ¬ conwayKnot.SmoothlySlice := by
  exact Submission.conway_knot_not_smoothly_slice
