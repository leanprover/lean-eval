import Mathlib.NumberTheory.LSeries.DirichletContinuation
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from The Weyl bound for Dirichlet L-functions of cube-free conductor

We formalise the statement of the main result from I. Petrow and M. P. Young,
`The Weyl bound for Dirichlet L-functions of cube-free conductor`, Annals of Math, 192 (2) 2020.
-/

set_option autoImplicit false

/-- A natural number `n` is cubefree if it is not divisible by `k ^ 3` for `k ≠ 1`. -/
def Nat.IsCubeFree (n : ℕ) : Prop := ∀ k, k ^ 3 ∣ n → k = 1

namespace DirichletWeylBound

open Complex



end DirichletWeylBound
