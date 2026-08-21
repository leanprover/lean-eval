import Mathlib.Data.Complex.Basic
import Mathlib.GroupTheory.Sylow
import Mathlib.RepresentationTheory.Character
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from The McKay Conjecture on character degrees

We formalise the statement of the main result from M. Cabanes and B. Späth,
`The McKay Conjecture on character degrees`, Annals of Math, 203 (3) 2026.
-/

set_option autoImplicit false

namespace McKayConjecture

open CategoryTheory Module Subgroup

variable (ℓ : ℕ) (X : Type*) [Group X] [Finite X]

/-- `Irr'(X)` is the set of complex irreducible characters of `X` whose degree is prime to `ℓ`. -/
def Irr' : Set (X → ℂ) :=
  {χ | ∃ V : FDRep ℂ X, Simple V ∧ V.character = χ ∧ ℓ.Coprime (finrank ℂ V)}



end McKayConjecture
