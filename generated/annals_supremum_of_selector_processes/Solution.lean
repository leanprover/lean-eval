/-
Copyright (c) 2025 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Probability.Distributions.SetBernoulli
import Submission
import ChallengeDeps
/-!
# Main Statements from On a conjecture of Talagrand on selector processes and a consequence
# on positive empirical processes

We formalise the statements of the main results from J. Park and H. T. Pham,
`On a conjecture of Talagrand on selector processes and a consequence on positive empirical
processes`, Annals of Math, 199 (3) 2024.
-/

set_option autoImplicit false

namespace SupremumOfSelectorProcesses

open MeasureTheory ProbabilityTheory Measure unitInterval Finset

open scoped NNReal ENNReal





/-- The constant `L` of Theorem 1.2. -/
@[reducible] noncomputable def L₂ : ℝ≥0 := Submission.SupremumOfSelectorProcesses.L₂

/-- The constant of Theorem 1.2 is positive. -/
theorem L₂_pos : L₂ > 0 := Submission.SupremumOfSelectorProcesses.L₂_pos

open Classical in
/--
Statement of Theorem 1.2:

There exists `L > 0` such that for any `0 < p < 1`, finite type `X`, and set `Λ` of functions from
`X` to `ℝ≥0` such that `0 < 𝔼[sup_{f ∈ Λ} ∑ i ∈ Xp, f i] < ∞`, the collection of sets

`{s ⊆ X | sup_{f ∈ Λ} ∑ i ∈ s, f i ≥ L * 𝔼[sup_{f ∈ Λ} ∑ i ∈ Xp, f i]}`

is `p-small`, where `Xp` is a binomial random subset of `X` with parameter `p`.

Note: The assumption `0 < 𝔼[sup_{f ∈ Λ} ∑ i ∈ Xp, f i] < ∞` is not explicitly stated in the theorem
but used in the last step of the proof where `𝔼 ≥ (L/L') * 𝔼` is a contradiction for `L > L'`.
-/
theorem theorem_1_2 (p : I) (hp₀ : 0 < p) (hp₁ : p < 1) (X : Type*) [Fintype X] (Λ : Set (X → ℝ≥0))
    (hE₀ : 0 < 𝔼⁻[⨆ f ∈ Λ, ∑ i ∈ Xp, (f i : ℝ≥0∞); Xp ∼ binomialSetDistribution X p])
    (hE : 𝔼⁻[⨆ f ∈ Λ, ∑ i ∈ Xp, (f i : ℝ≥0∞); Xp ∼ binomialSetDistribution X p] < ∞) :
    IsSmall p {s : Set X | ⨆ f ∈ Λ, ∑ i ∈ s, (f i : ℝ≥0∞) ≥
        L₂ * 𝔼⁻[⨆ f ∈ Λ, ∑ i ∈ Xp, (f i : ℝ≥0∞); Xp ∼ binomialSetDistribution X p]} := Submission.SupremumOfSelectorProcesses.theorem_1_2 p hp₀ hp₁ X Λ hE₀ hE



/-- The constant `L` of Theorem 1.3. -/
@[reducible] noncomputable def L₃ : ℝ≥0 := Submission.SupremumOfSelectorProcesses.L₃

/-- The constant of Theorem 1.3 is positive. -/
theorem L₃_pos : L₃ > 0 := Submission.SupremumOfSelectorProcesses.L₃_pos

open Classical in
/--
Statement of Theorem 1.3:

There exists `L > 0` such that for any `N > 0`, i.i.d random variables `Y_1, …, Y_N` distributed
according to a Borel probability measure `ν` on a Polish space `𝕋`, if `𝓕` is a finite set of
non-negative functions in `L∞(𝕋)` and `0 < 𝔼[sup_{f ∈ 𝓕} Z Y f] < ∞` then there exists a finite
collection `𝓒` of pairs `(g, t)` where `g : 𝕋 → ℝ≥0`, `t > 0` such that

`{sup_{f ∈ 𝓕} Z N Y f ≥ L * 𝔼[sup_{f ∈ 𝓕} Z N Y f] } ⊆ ⋃ (g,t) ∈ 𝓒, {t ≤ Z N Y g}`

and

`∑ (g,t) ∈ 𝓒, P(t ≤ Z N Y g) ≤ 2⁻¹`.

Note: The requirement that the collection `𝓒` be finite is not explicitly stated in the paper.
However, `𝓒` must at least be assumed to be countable in order for the sum to make sense,
and the collections `𝓒` produced by the proof are indeed finite.

-/
theorem theorem_1_3 (N : ℕ) (N_pos : N > 0) (𝕋 : Type*) (t𝕋 : TopologicalSpace 𝕋)
    (p𝕋 : PolishSpace 𝕋)
    (m𝕋 : MeasurableSpace 𝕋) (b𝕋 : BorelSpace 𝕋) (ν : Measure 𝕋) (hν : IsProbabilityMeasure ν)
    (Ω : Type*) (mΩ : MeasurableSpace Ω) (P : Measure Ω) (Y : Fin N → Ω → 𝕋)
    (Y_indep : iIndepFun Y P) (Y_law_ν : ∀ i, HasLaw (Y i) ν P)
    (𝓕 : Set {f : 𝕋 → ℝ≥0 // Measurable f ∧ MemLp f ∞ ν}) (h𝓕 : Finite 𝓕)
    (hZ₀ : 0 < 𝔼⁻[⨆ f ∈ 𝓕, (Z N Y f ·); P]) (hZ : 𝔼⁻[⨆ f ∈ 𝓕, (Z N Y f ·); P] < ∞) :
    ∃ 𝓒 : Finset ({g : 𝕋 → ℝ≥0 // Measurable g} × {t : ℝ≥0 | t > 0}),
      {ω | ⨆ f ∈ 𝓕, Z N Y f ω ≥ L₃ * 𝔼⁻[⨆ f ∈ 𝓕, (Z N Y f ·); P]} ⊆ ⋃ c ∈ 𝓒, {ω | c.2 ≤ Z N Y c.1 ω}
      ∧ ∑ c : 𝓒, P {ω | c.val.2 ≤ Z N Y c.val.1 ω} ≤ 2⁻¹ := Submission.SupremumOfSelectorProcesses.theorem_1_3 N N_pos 𝕋 t𝕋 p𝕋 m𝕋 b𝕋 ν hν Ω mΩ P Y Y_indep Y_law_ν 𝓕 h𝓕 hZ₀ hZ

end SupremumOfSelectorProcesses
