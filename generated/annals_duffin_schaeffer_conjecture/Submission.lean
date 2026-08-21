/-
Copyright (c) 2025 Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Katerina Hristova, Kevin Buzzard
-/

import Mathlib.Topology.MetricSpace.HausdorffDimension
import Submission.Helpers
import ChallengeDeps
/-!
# Main Statements from On the Duffin-Schaeffer conjecture

We formalise the statements of the main results from D. Koukoulopoulos and J. Maynard,
`On the Duffin-Schaeffer conjecture`, Annals of Math, 192 (1) 2020.

## Implementation Details

In the paper, `ℕ` denotes the positive integers, which are denoted `ℕ+` in Lean.
Hence, no changes to the domains of the functions `ψ` and `ψ⋆` have been made in the formalisation.
-/


namespace Submission

open _root_.DuffinSchaefferConjecture
set_option autoImplicit false

namespace DuffinSchaefferConjecture

open NNReal ENNReal MeasureTheory

open scoped Nat





/--
Statement of Theorem 1:

If for `ψ : ℕ → ℝ≥0`, the infinite series `∑ (ψ q * φ q) / q`, where `φ` is the
Euler totient function, diverges, then the set `𝒜` defined above has Lebesgue measure `1`.
-/
theorem theorem_1 (ψ : ℕ+ → ℝ≥0) (hdivergence : ¬ Summable fun q ↦ (ψ q * φ q) / q) :
    MeasurableSet (𝒜 ψ) ∧ volume (𝒜 ψ) = 1 := by
  sorry





/--
Statement of Theorem 2(a):

Let `ψ : ℕ → ℝ≥0`, `𝒦` and `ψ⋆` be as above. Then, if `∑ ψ⋆ (q)` converges, `𝒦` has Lebesgue
measure `0`.
-/
theorem theorem_2_a (ψ : ℕ+ → ℝ≥0) (hψ : ∑' q, ψ_star ψ q < ∞) :
    MeasurableSet (𝒦 ψ) ∧ volume (𝒦 ψ) = 0 := by
  sorry

/--
Statement of Theorem 2(b):

Let `ψ : ℕ → ℝ≥0`, `𝒦` and `ψ⋆` be as above. Then, if `∑ ψ⋆ (q)` diverges, `𝒦` has Lebesgue
measure `1`.
-/
theorem theorem_2_b (ψ : ℕ+ → ℝ≥0) (hψ : ∑' q, ψ_star ψ q = ∞) :
    MeasurableSet (𝒦 ψ) ∧ volume (𝒦 ψ) = 1 := by
  sorry



/--
Statement of Corollary 3:

For a function `ψ : ℕ → [0, 1/2]`, the set `𝒜` and the element `s` defined as above,
the Hausdorff dimension of `𝒜` is the minimum of `s` and `1`.
-/
theorem corollary_3 (ψ : ℕ+ → ℝ≥0) (hψ : ∀ n, ψ n ∈ Set.Icc 0 (1 / 2)) :
    dimH (𝒜 ψ) = min (s_inf ψ) 1 := by
  sorry

end DuffinSchaefferConjecture

end Submission
