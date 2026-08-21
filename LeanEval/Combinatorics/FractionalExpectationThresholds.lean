/-
Copyright (c) 2026 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Probability.Distributions.SetBernoulli
import EvalTools.Markers

/-!
# Main Statement from Thresholds versus fractional expectation-thresholds

We formalise the statement of the main result from K. Frankston, J. Kahn, B. Narayanan, and J. Park,
`Thresholds versus fractional expectation-thresholds`, Annals of Math, 194 (2) 2021.
-/

set_option autoImplicit false

namespace FractionalExpectationThresholds

open ProbabilityTheory unitInterval Set

open scoped NNReal

section Definitions

open Classical in
/-- We say that a collection `𝓕` of subsets of `X` is `weakly p-small` if there exists
`g : Set X → ℝ≥0` such that `∀ T ∈ 𝓕, ∑ S ⊆ T, g(S) ≥ 1` and `∑ S ⊆ X, g(S) p^|S| ≤ 1/2`. -/
def IsWeaklySmall {X : Type*} [Fintype X] (p : I) (𝓕 : Set (Set X)) : Prop :=
  ∃ g : Set X → ℝ≥0, (∀ T ∈ 𝓕, ∑ S with S ⊆ T, g S ≥ 1) ∧ ∑ S, g S * (p : ℝ) ^ S.ncard ≤ 2⁻¹

open Classical in
/-- Given an increasing collection `𝓕` of subsets of `X` such that `𝓕 ≠ ∅` and  `𝓕 ≠ 𝓟 X`, we
define the `threshold`, `p_c(𝓕)` of `𝓕` as the (unique) `p` such that the Bernoulli `p` product
measure of `𝓕` equals `1 / 2`. -/
noncomputable def p_c {X : Type*} (𝓕 : Set (Set X)) : I :=
  if h : ∃ p, setBer(univ, p).real (𝓕 : Set (Set X)) = 2⁻¹ then Classical.choose h else 0

/-- Given a collection `𝓕` of subsets of `X`, we define the `fractional expectation-threshold` by
`q_f(𝓕) := max {p | 𝓕 is weakly p-small}`. -/
noncomputable def q_f {X : Type*} [Fintype X] (𝓕 : Set (Set X)) : I :=
  sSup {p | IsWeaklySmall p 𝓕}

/-- Given a collection `𝓕` of subsets of `X`, we define `l(𝓕)` to be the size of a largest minimal
element of `𝓕`. -/
noncomputable def l {X : Type*} (𝓕 : Set (Set X)) : ℕ :=
  ⨆ (A : 𝓕) (_ : IsMin A), (A : Set X).ncard

end Definitions

/-- The constant `K` in Theorem 1.1. -/
@[eval_problem]
noncomputable def K : ℝ := sorry

/--
Statement of Theorem 1.1:

There exists a universal constant `K` such that for any finite set `X` and any increasing
collection of sets `𝓕` such that `l(𝓕)` is at least `2`,

`p_c(𝓕) ≤ K * q_f(𝓕) * log l(𝓕)`.

Note: The assumption that `l(𝓕)` is at least `2` is not explicitly in the paper but is needed
because if `l(𝓕) = 1` then `Real.log (l 𝓕) = 0`, but `p_c 𝓕 ∈ (0,1)` (so the inequality clearly
cannot hold).
-/
@[eval_problem]
theorem theorem_1_1 (X : Type*) [Fintype X] (𝓕 : Set (Set X)) (h𝓕 : IsUpperSet 𝓕)
    (hl𝓕 : 2 ≤ l 𝓕) : p_c 𝓕 ≤ K * q_f 𝓕 * Real.log (l 𝓕) := by
  sorry

end FractionalExpectationThresholds
