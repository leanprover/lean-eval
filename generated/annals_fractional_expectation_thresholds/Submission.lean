/-
Copyright (c) 2026 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Probability.Distributions.SetBernoulli
import Submission.Helpers
import ChallengeDeps
/-!
# Main Statement from Thresholds versus fractional expectation-thresholds

We formalise the statement of the main result from K. Frankston, J. Kahn, B. Narayanan, and J. Park,
`Thresholds versus fractional expectation-thresholds`, Annals of Math, 194 (2) 2021.
-/


namespace Submission

open _root_.FractionalExpectationThresholds
set_option autoImplicit false

namespace FractionalExpectationThresholds

open ProbabilityTheory unitInterval Set

open scoped NNReal

section Definitions









end Definitions

/-- The constant `K` in Theorem 1.1. -/
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
theorem theorem_1_1 (X : Type*) [Fintype X] (𝓕 : Set (Set X)) (h𝓕 : IsUpperSet 𝓕)
    (hl𝓕 : 2 ≤ l 𝓕) : p_c 𝓕 ≤ K * q_f 𝓕 * Real.log (l 𝓕) := by
  sorry

end FractionalExpectationThresholds

end Submission
