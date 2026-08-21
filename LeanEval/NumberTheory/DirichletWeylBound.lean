/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.NumberTheory.LSeries.DirichletContinuation
import EvalTools.Markers

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

/--
Statement of Corollary 1.3:

Suppose `χ` has cubefree conductor `q`. Then
`|L(1/2 + it, χ)| ≪ q ^ (1/6 + ε) * (1 + |t|) ^ (1/6 + ε)`.
-/
@[eval_problem]
theorem corollary_1_3 (ε : ℝ) (hε : 0 < ε) : ∃ C : ℝ,
    ∀ q (_hq : q.IsCubeFree) [NeZero q] (χ : DirichletCharacter ℂ q) (_hχ : χ.IsPrimitive) (t : ℝ),
      ‖χ.LFunction (1 / 2 + I * t)‖ ≤ C * q ^ (1 / 6 + ε) * (1 + |t|) ^ (1 / 6 + ε) := by
  sorry

end DirichletWeylBound
