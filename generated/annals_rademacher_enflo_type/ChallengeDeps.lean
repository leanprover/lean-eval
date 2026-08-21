import Mathlib.Probability.ProductMeasure
import Mathlib.Probability.Distributions.Bernoulli
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
# Main Statement from Rademacher type and Enflo type coincide

We formalise the statement of the main result from P. Ivanisvili, R. van Handel, and A. Volberg,
`Rademacher type and Enflo type coincide`, Annals of Math, 192 (2) 2020.
-/

set_option autoImplicit false

namespace RademacherEnfloType

open Function MeasureTheory ProbabilityTheory Measure NNReal

open scoped ENNReal

instance : Neg ({-1, 1} : Set ℤ) where
  neg x := ⟨Neg.neg (α := ℤ) (x : ℤ), by grind⟩

/-- Definition of Rademacher distribution as a measure on `{-1, 1}` (as a subset of `ℤ`). -/
noncomputable def rademacherDistribution : Measure ({-1, 1} : Set ℤ) :=
  bernoulliMeasure ⟨1, by decide⟩ ⟨-1, by decide⟩ ⟨1 / 2, by norm_num⟩

/-- Definition of the distribution of a sequence of independent Rademacher variables
indexed by the type `ι`, which is a measure on `ι → {-1,1}`. -/
noncomputable def rademacherProductDistribution (ι : Type*) :
    Measure (ι → ({-1, 1} : Set ℤ)) :=
  infinitePi (fun _ : ι ↦ rademacherDistribution)

/- Let `X` be a Banach space. -/
variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]

/-- Definition of the discrete partial derivative. Given a function `f : {-1, 1}ⁿ → X`
we define

`Dⱼf(ε) := (f(ε₁, …, εⱼ, …, εₙ) - f(ε₁, …, -εⱼ, …, εₙ)) / 2`.
-/
noncomputable def D {n : ℕ} (j : Fin n) (f : (Fin n → ({-1, 1} : Set ℤ)) → X)
      (ε : Fin n → ({-1, 1} : Set ℤ)) : X :=
  (1 / (2 : ℝ)) • (f ε - f (update ε j (- ε j)))

/- Let `X` be a Banach space. -/
variable (X : Type*) [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]

/-- `IsRademacherType X C p` is the proposition that for all `n ≥ 1`, and `x₁, …, xₙ ∈ X`

`𝔼‖∑ j ∈ {1,…,n}, εⱼxⱼ‖ᵖ ≤ Cᵖ ∑ j ∈ {1,…,n}, ‖xⱼ‖ᵖ`

where `ε₁, …, εₙ` is a sequence of independent Rademacher variables.
-/
def IsRademacherType (C : ℝ≥0∞) (p : ℝ) : Prop :=
  ∀ n ≥ 1, ∀ (x : Fin n → X),
    𝔼⁻[‖ ∑ j : Fin n, ((ε j) : ℝ) • (x j) ‖ₑ ^ p; ε ∼ rademacherProductDistribution (Fin n)]
    ≤ C ^ p * ∑ j : Fin n, ‖ x j ‖ₑ ^ p

/-- `Tᴿₚ(X)` is defined to be the infimum over all `C` such that the
proposition `IsRademacherType X C p` holds. -/
noncomputable def TR (p : ℝ) : ℝ≥0∞ := sInf {C : ℝ≥0∞ | IsRademacherType X C p}

/-- `IsEnfloType X C p` is the proposition that for all `n ≥ 1`, and `f : {-1,1}ⁿ → X`

`𝔼‖ (f(ε) - f(-ε)) / 2 ‖ᵖ ≤ Cᵖ ∑ j ∈ {1,…,n}, 𝔼‖Dⱼf(ε)‖ᵖ`

where `ε₁, …, εₙ` is a sequence of independent Rademacher variables.
-/
def IsEnfloType (C : ℝ≥0∞) (p : ℝ) : Prop :=
    ∀ n ≥ 1, ∀ (f : (Fin n → ({-1, 1} : Set ℤ)) → X),
  𝔼⁻[‖ (1 / (2 : ℝ)) • (f ε - f (- ε)) ‖ₑ ^ p; ε ∼ rademacherProductDistribution (Fin n)]
  ≤ C ^ p * ∑ j : Fin n, 𝔼⁻[‖ D j f ε ‖ₑ ^ p; ε ∼ rademacherProductDistribution (Fin n)]

/-- `Tᴱₚ(X)` is defined to be the infimum over all `C` such that the
proposition `IsEnfloType X C p` holds. -/
noncomputable def TE (p : ℝ) : ℝ≥0∞ := sInf {C : ℝ≥0∞ | IsEnfloType X C p}



end RademacherEnfloType
