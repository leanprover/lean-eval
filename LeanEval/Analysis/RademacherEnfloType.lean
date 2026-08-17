/-
Copyright (c) 2025 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Probability.ProductMeasure
import Mathlib.Probability.Distributions.Bernoulli
import LeanEval.Analysis.AnnalsProbabilityNotation
import EvalTools.Markers

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

/--
Statement of Theorem 1.1:

For any `p ∈ [1,2]`, and Banach space `X`

`TRₚ(X) ≤ TEₚ(X) ≤ (π / √2) TRₚ(X)`.
-/
@[eval_problem]
theorem theorem_1_1 (p : ℝ) (h1p : 1 ≤ p) (hp2 : p ≤ 2) :
    TR X p ≤ TE X p ∧ TE X p ≤ (pi / sqrt 2) * TR X p := by
  sorry

end RademacherEnfloType
