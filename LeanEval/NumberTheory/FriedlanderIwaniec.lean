/-
Copyright (c) 2026 Project Numina. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Numina Team
-/
import Mathlib
import EvalTools.Markers

namespace FriedlanderIwaniec

/-!
# Friedlander–Iwaniec theorem

There are infinitely many primes of the form `a² + b⁴`.

 See <https://en.wikipedia.org/wiki/Friedlander%E2%80%93Iwaniec_theorem>.
-/

section Main

open Nat

@[eval_problem]
theorem friedlander_iwaniec : {p : ℕ | p.Prime ∧ ∃ a b, p = a ^ 2 + b ^ 4}.Infinite := by
  sorry

end Main

end FriedlanderIwaniec
