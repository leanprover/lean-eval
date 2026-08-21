import ChallengeDeps

/-
Copyright (c) 2026 Justus Springer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Justus Springer
-/

import Mathlib.Analysis.SpecialFunctions.Log.Base
/-!
# Main Statement from Improved bounds for the sunflower lemma

We formalise the statement of the main result from R. Alweiss, S. Lovett, K. Wu, and J. Zhang,
`Improved bounds for the sunflower lemma`, Annals of Math, 194 (3) 2021.
-/

set_option autoImplicit false

namespace Set

variable {X : Type*}





end Set

namespace ImprovedBoundsSunflowerLemma

open Real



/-- The absolute constant `C` in Theorem 1.4. Although not explicitly stated in the paper,
the constant `C` doesn't depend on `r`. -/
noncomputable def C : ℝ := sorry

/--
Statement of Theorem 1.4 (Main theorem, sunflowers):

Let `r ≥ 3`. For some constant `C`, any `w`-set system `F` of size
`|F| ≥ (C * r ^ 3 * log w * log log w) ^ w` contains an `r`-sunflower.

Note: We require `w ≥ 2`, as the paper assumes `log log w > 0`.
-/
theorem theorem_1_4 (r : ℕ) (hr : r ≥ 3) (X : Type*) [Finite X] (ℱ : Set (Set X)) (w : ℕ)
      (hw : w ≥ 2) (hℱ₁ : ℱ.IsSystem w) (hℱ₂ : ℱ.ncard ≥ lowerBound r C w) :
      ∃ S ⊆ ℱ, S.IsSunflower r := by
  sorry

end ImprovedBoundsSunflowerLemma
