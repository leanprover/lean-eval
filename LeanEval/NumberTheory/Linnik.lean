/-
Copyright (c) 2026 Project Numina. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Numina Team
-/
import Mathlib
import EvalTools.Markers

namespace Linnik

/-!
# Linnik's theorem (L = 5.5)

The least prime in the arithmetic progression `a mod d` (for `a` coprime to `d`)
is bounded polynomially in `d`, with the explicit Linnik constant `L = 5.5`
(due to Heath-Brown, 1992).

 See D. R. Heath-Brown, *Zero-free regions for Dirichlet L-functions, and the
 least prime in an arithmetic progression*, Proc. London Math. Soc. (3) 64
 (1992), no. 2, 265–338. <https://doi.org/10.1112/plms/s3-64.2.265>
-/

section Main

open Nat

/-- The least prime in the progression `a, a + d, a + 2d, …`
(or `0` if no such prime exists). -/
noncomputable def p (a d : ℕ) : ℕ := sInf ({a + k * d | k : ℕ} ∩ {p | p.Prime})

/-- Linnik's theorem with the explicit constant `L = 5.5`: the least prime in the
progression `a mod d` is bounded by `c * d ^ 5.5` for some constant `c`. -/
@[eval_problem]
theorem linnik : ∃ c : ℝ, ∀ ⦃a d : ℕ⦄,
    0 < a → a < d → a.Coprime d → p a d ≤ c * (↑d : ℝ) ^ (5.5 : ℝ) := by
  sorry

end Main

end Linnik
