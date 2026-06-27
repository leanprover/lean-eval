/-
Copyright (c) 2026 Project Numina. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Numina Team
-/
import Mathlib
import EvalTools.Markers

namespace Linnik

/-!
# Linnik's theorem

The least prime in the arithmetic progression `a mod d` (for `a` coprime to `d`)
is bounded polynomially in `d`.

 See <https://en.wikipedia.org/wiki/Linnik's_theorem>.
-/

section Main

open Nat

/-- The least prime in the progression `a, a + d, a + 2d, …`
(or `0` if no such prime exists). -/
noncomputable def p (a d : ℕ) : ℕ := sInf ({a + k * d | k : ℕ} ∩ {p | p.Prime})

@[eval_problem]
theorem linnik : ∃ c L : ℝ, ∀ ⦃a d : ℕ⦄,
    0 < a → a < d → a.Coprime d → p a d ≤ c * (↑d : ℝ) ^ L := by
  sorry

end Main

end Linnik
