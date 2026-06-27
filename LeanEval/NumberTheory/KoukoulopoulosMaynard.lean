/-
Copyright (c) 2026 Project Numina. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Numina Team
-/
import Mathlib
import EvalTools.Markers

namespace KoukoulopoulosMaynard

/-!
# Duffin–Schaeffer theorem (Koukoulopoulos–Maynard)

For a nonnegative function `f`, almost every real is approximable by infinitely
many reduced fractions `p / q` with `|x - p/q| < f q / q` if and only if the
series `∑ φ(n) f(n) / n` diverges.

 See <https://en.wikipedia.org/wiki/Duffin%E2%80%93Schaeffer_theorem>.
-/

section Main

open MeasureTheory Set Nat

@[eval_problem]
theorem koukoulopoulos_maynard {f : ℕ → ℝ} (hf : ∀ n, 0 < f n) :
    (∀ᵐ (x : ℝ), {(p, q) : ℕ × ℕ | p.Coprime q ∧ |x - p / (↑q : ℝ)|
      < f q / (↑q : ℝ)}.Finite) ↔ Summable fun n ↦ φ n * f n / (↑n : ℝ) := by
  sorry

end Main

end KoukoulopoulosMaynard
