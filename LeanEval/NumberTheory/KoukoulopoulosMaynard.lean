/-
Copyright (c) 2026 Project Numina. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Numina Team
-/
import Mathlib
import EvalTools.Markers

namespace LeanEval.NumberTheory.KoukoulopoulosMaynard

/-!
# Duffin–Schaeffer theorem (Koukoulopoulos–Maynard)

For a nonnegative function `ψ`, almost every real is approximable by infinitely
many reduced fractions `p / q` with `|x - p/q| ≤ ψ q / q` if the
series `∑ φ(n) ψ(n) / n` diverges.

 See <https://en.wikipedia.org/wiki/Duffin%E2%80%93Schaeffer_theorem>.
-/

section Main

open MeasureTheory Set Nat

@[eval_problem]
theorem koukoulopoulos_maynard {ψ : ℕ → ℝ} (hψ : ∀ n, 0 ≤ ψ n)
    (hdiv : ¬ Summable fun q ↦ φ q * ψ q / (q : ℝ)) :
    ∀ᵐ x : ℝ, {(a, q) : ℤ × ℕ | a.gcd q = 1 ∧
      |x - a / (q : ℝ)| ≤ ψ q / (q : ℝ)}.Infinite := by
  sorry

end Main

end LeanEval.NumberTheory.KoukoulopoulosMaynard
