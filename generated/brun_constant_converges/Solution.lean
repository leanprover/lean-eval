import ChallengeDeps
import Submission

open LeanEval.NumberTheory.BrunConstant
open Filter Finset MeasureTheory
open scoped BigOperators Topology

theorem brun_constant_converges :
    Summable twinPrimeReciprocalTerm := by
  exact Submission.brun_constant_converges
