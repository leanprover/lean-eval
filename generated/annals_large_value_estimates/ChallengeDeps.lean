import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from New large value estimates for Dirichlet polynomials

We formalise the statement of the main result from L. Guth and J. Maynard,
`New large value estimates for Dirichlet polynomials`, Annals of Math, 203 (2) 2026.
-/

set_option autoImplicit false

namespace LargeValueEstimates

open Asymptotics Complex

/-- The bound `N^2 V^(-2) + N^(18/5) V^(-4) + T N^(12/5) V^(-4)` appearing in Theorem 1.1. -/
noncomputable def bound (N : ℕ) (V T : ℝ) : ℝ :=
  N ^ 2 * V ^ (- 2 : ℤ) + N ^ (18 / 5 : ℝ) * V ^ (- 4 : ℤ) + T * N ^ (12 / 5 : ℝ) * V ^ (- 4 : ℤ)



end LargeValueEstimates
