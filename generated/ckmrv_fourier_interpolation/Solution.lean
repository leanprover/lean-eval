import ChallengeDeps
import Submission

open LeanEval.Analysis.CKMRVInterpolation
open Filter Topology
open scoped FourierTransform SchwartzMap

theorem ckmrv_fourier_interpolation :
    CKMRV 8 1 ∧ CKMRV 24 2 := by
  exact Submission.ckmrv_fourier_interpolation
