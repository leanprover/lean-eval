import Mathlib.Analysis.SpecialFunctions.Log.Base
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Improved bounds for the sunflower lemma

We formalise the statement of the main result from R. Alweiss, S. Lovett, K. Wu, and J. Zhang,
`Improved bounds for the sunflower lemma`, Annals of Math, 194 (3) 2021.
-/

set_option autoImplicit false

namespace Set

variable {X : Type*}

/-- A `r`-sunflower is a finite collection of `r` sets so that the intersection of each pair is
equal to the intersection of all of them. See Definition 1.1. -/
def IsSunflower (r : ℕ) (S : Set (Set X)) : Prop :=
  S.ncard = r ∧ S.Pairwise (fun A B ↦ A ∩ B = ⋂₀ S)

/-- The condition that `ℱ` is a `w`-set system, namely that each element has size at most `w`
(see second sentence of the introduction). -/
def IsSystem (w : ℕ) (ℱ : Set (Set X)) : Prop := ∀ A ∈ ℱ, A.ncard ≤ w

end Set

namespace ImprovedBoundsSunflowerLemma

open Real

/-- The lower bound from Theorem 1.4. We follow the convention of the authors and use the
logarithm in base 1.9; see the paragraph directly after Theorem 1.4. -/
noncomputable def lowerBound (r : ℕ) (C : ℝ) (w : ℕ) : ℝ :=
  (C * r ^ 3 * logb 1.9 w * logb 1.9 (logb 1.9 w)) ^ w





end ImprovedBoundsSunflowerLemma
