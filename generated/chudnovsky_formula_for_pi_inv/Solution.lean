import Mathlib.Analysis.Real.Pi.Chudnovsky
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

open scoped Real

theorem chudnovsky_formula_for_pi_inv :
    chudnovskySum = π⁻¹ := by
  exact Submission.chudnovsky_formula_for_pi_inv
