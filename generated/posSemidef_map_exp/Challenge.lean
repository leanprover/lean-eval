import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Lake.Toml
import Lake.Util.Message
import Lean

open scoped MatrixOrder Matrix

theorem posSemidef_map_exp {n : Type*} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℝ} (hA : A.PosSemidef) :
    (A.map Real.exp).PosSemidef := by
  sorry
