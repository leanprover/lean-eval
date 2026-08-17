/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import EvalTools.Markers

/-!
# Main Statement from New large value estimates for Dirichlet polynomials

We formalise the statement of the main result from L. Guth and J. Maynard,
`New large value estimates for Dirichlet polynomials`, Annals of Math, 203 (2) 2026.
-/

set_option autoImplicit false

namespace LargeValueEstimates

open Asymptotics Complex

/-- The bound `N^2 V^(-2) + N^(18/5) V^(-4) + T N^(12/5) V^(-4)` appearing in Theorem 1.1. -/
noncomputable def bound (N : ℕ) (V T : ℝ) : ℝ :=
  N ^ 2 * V ^ (- 2 : ℤ) + N ^ (18 / 5 : ℝ) * V ^ (- 4 : ℤ) + T * N ^ (12 / 5 : ℝ) * V ^ (- 4 : ℤ)

/--
Statement of Theorem 1.1 (Large values estimate):

Suppose `(bₙ)` is a sequence of complex numbers with `|bₙ| ≤ 1`, and `(tᵣ)` for `r ≤ R` is a
sequence of `1`-separated points in `[0, T]` such that

`|∑_N^2N bₙ n^(itᵣ)| ≥ V`

for all `r ≤ R`. Then we have

`R ≤ T^(o(1)) * (N^2 V^(-2) + N^(18/5) V^(-4) + T N^(12/5) V^(-4))`.

Note: The inequality may be false at `T = 1`, so we must impose `T > 1`.
-/
@[eval_problem]
theorem theorem_1_1 : ∃ o : ℝ → ℝ, o =o[Filter.atTop] (1 : ℝ → ℝ) ∧
    ∀ (b : ℕ → ℂ) (_hb : ∀ n, ‖b n‖ ≤ 1) (N : ℕ) (V : ℝ) (T : ℝ) (R : ℕ) (t : Fin R → ℝ),
    N > 0 → V > 0 → T > 1 → -- these assumptions are necessary but not stated in the paper
    (∀ i j, i ≠ j → |t i - t j| ≥ 1) → (∀ i, t i ∈ Set.Icc 0 T) →
    (∀ r, ‖∑ n ∈ Finset.Icc N (2 * N), b n * n ^ (I * t r)‖ ≥ V) →
    R ≤ T ^ (o T) * bound N V T := by
  sorry

end LargeValueEstimates
