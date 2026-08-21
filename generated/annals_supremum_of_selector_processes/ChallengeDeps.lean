import Mathlib.Probability.Distributions.SetBernoulli
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Notation for AnnalsChallenge

This file defines notation (mostly probability-theoretic) for the AnnalsChallenge project.

Ported verbatim from `AnnalsChallenge/Notation.lean` in
<https://github.com/ImperialCollegeLondon/AnnalsChallenge> (v1.0.0, `e32eb14`). It is a
trusted support module, not a benchmark problem: it contains no `sorry` and no
`@[eval_problem]` declarations. It is imported by `LeanEval.Analysis.RademacherEnfloType`
and `LeanEval.Analysis.SupremumOfSelectorProcesses`.
-/

set_option autoImplicit false

namespace ProbabilityTheory

open MeasureTheory Lean

/-- Suppose `P : Measure Ω`, `X : Ω → E`:

`𝔼[X; P] = ∫ ω, ↑(X ω) ∂P`

is notation for the integral (expectation) of a function `X` with respect to the measure `P`. -/
macro "𝔼[" X:term "; " P:term "]" : term => `(∫ ω, ↑($X ω) ∂$P)

/-- Suppose `μ : Measure E`

`𝔼[t; X ∼ μ] = ∫ X; t ∂μ`

where `X` is a variable and `t` is a term (possibly) depending on `X`. In probability theory
this represents the expectation of a function of `X` when `X` has law `μ`. For example we
could write `𝔼[X ^ 2; X ∼ μ]` for the second moment of `μ`.
-/
notation "𝔼[" t "; " X " ∼ " μ "]" => MeasureTheory.integral μ (fun X ↦ ↑t)

/-- Suppose `P : Measure Ω`, `X : Ω → ℝ≥0∞`:

`𝔼⁻[X; P] = ∫⁻ ω, ↑(X ω) ∂P`

is notation for the lintegral (expectation) of a function `X` with respect to the measure `P`. -/
macro "𝔼⁻[" X:term "; " P:term "]" : term => `(∫⁻ ω, ↑($X ω) ∂$P)

/-- Suppose `μ : Measure ℝ≥0∞`

`𝔼[t; X ∼ μ] = ∫ X; t ∂μ`

where `X` is a variable and `t` is a term (possibly) depending on `X`. In probability theory
this represents the expectation of a function of `X` when `X` has law `μ`. For example we
could write `𝔼⁻[X ^ 2; X ∼ μ]` for the second moment of `μ`.
-/
notation "𝔼⁻[" t "; " X " ∼ " μ "]" => MeasureTheory.lintegral μ (fun X ↦ ↑t)

end ProbabilityTheory
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

/-- Definition of a binomial random subset of `X` with parameter `p`. -/
noncomputable def binomialSetDistribution (X : Type*) (p : I) : Measure (Set X) :=
  setBernoulli Set.univ p

open Classical in
/-- Definition of a collection of sets being `p-small`. -/
def IsSmall {X : Type*} [Fintype X] (p : I) (𝓕 : Set (Set X)) : Prop :=
  ∃ 𝓖 : Set (Set X), 𝓕 ⊆ ⋃ s ∈ 𝓖, {t | s ⊆ t} ∧ (∑ s ∈ 𝓖, (p : ℝ) ^ s.ncard ≤ 2⁻¹)







/-- Given a sequence of `𝕋`-valued random variables `Y_1, …, Y_N` and a function `f : 𝕋 → ℝ≥0`,
define the random variable

`Z N Y f := N⁻¹ ∑ i ∈ {1,…,N}, f(Yᵢ)`

When the sequence `Y_1, …, Y_N` is i.i.d, we call `Z N Y f` an empirical process.
-/
noncomputable def Z {Ω 𝕋 : Type*} (N : ℕ) (Y : Fin N → Ω → 𝕋) (f : 𝕋 → ℝ≥0) (ω : Ω) : ℝ≥0 :=
  (N : ℝ≥0)⁻¹ * ∑ i : Fin N, f (Y i ω)







end SupremumOfSelectorProcesses
