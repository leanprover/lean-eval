import Mathlib.Algebra.Field.ZMod
import Mathlib.Combinatorics.Additive.CovBySMul
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from On a conjecture of Marton

We formalise the statement of the main result from W. T. Gowers, B. Green, F. Manners, and T. Tao,
`On a conjecture of Marton`, Annals of Math, 201 (2) 2025.
-/

set_option autoImplicit false

namespace ConjectureOfMarton

open Pointwise

variable (n : ℕ)

/-- `F n` is the finite vector space `(𝔽₂)ⁿ`. -/
abbrev F := Fin n → ZMod 2



end ConjectureOfMarton
