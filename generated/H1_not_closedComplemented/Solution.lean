import ChallengeDeps
import Submission

open LeanEval.Analysis
open MeasureTheory Submodule

theorem H1_not_closedComplemented :
    ¬ H1.ClosedComplemented := by
  exact Submission.H1_not_closedComplemented
