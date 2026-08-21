/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.Algebra.Field.ZMod
import Mathlib.Combinatorics.Additive.CovBySMul
import EvalTools.Markers

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

/--
Statement of Theorem 1.2:

Suppose that `A ⊂ (𝔽₂)ⁿ` is a set with `|A + A| ≤ K|A|`. Then `A` is covered by at most `2 K ^ 12`
cosets of some subgroup `H ≤ (𝔽₂)ⁿ` of size at most `|A|`.

Note that the set `A` must be nonempty, but this is left implicit in the paper.
-/
@[eval_problem]
theorem theorem_1_2 (A : Set (F n)) (K : ℝ) (h₀ : A.Nonempty) (h : (A + A).ncard ≤ K * A.ncard) :
    ∃ H : AddSubgroup (F n), Nat.card H ≤ A.ncard ∧ CovByVAdd (F n) (2 * K ^ 12) A H := by
  sorry

end ConjectureOfMarton
