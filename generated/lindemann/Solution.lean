import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

open Polynomial

theorem lindemann :
    Transcendental ℤ (Real.exp 1) ∧ Transcendental ℤ Real.pi := by
  exact Submission.lindemann
