/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.Data.Complex.Basic
import Mathlib.GroupTheory.Sylow
import Mathlib.RepresentationTheory.Character
import EvalTools.Markers

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

/--
Statement of Theorem 1.1:

Let `X` be a finite group, `ℓ` a prime and `S` a Sylow `ℓ`-subgroup of `X`. Let `Irr_ℓ'(X)` denote
the set of complex irreducible characters of `X` whose degree is prime to `ℓ`. Then
`|Irr_ℓ'(X)| = |Irr_ℓ'(N_X(S))|`.
-/
@[eval_problem]
theorem theorem_1_1 (hℓ : ℓ.Prime) (S : Sylow ℓ X) :
    (Irr' ℓ X).ncard = (Irr' ℓ (normalizer S : Subgroup X)).ncard := by
  sorry

end McKayConjecture
