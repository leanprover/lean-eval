/-
Copyright (c) 2026 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.Analysis.Normed.Lp.PiLp
import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Submission
import ChallengeDeps
/-!
# Main Statements from Pointwise ergodic theorems for non-conventional bilinear polynomial averages

We formalise the statements of the main results from B. Krause, M. Mirek, and T. Tao,
`Pointwise ergodic theorems for non-conventional bilinear polynomial averages`,
Annals of Math, 195 (3) 2022.
-/

set_option autoImplicit false

namespace PointwiseErgodicTheorems

open MeasureTheory Polynomial Finset Filter Topology

open scoped ENNReal NNReal PNat





/- We assume that `(X, μ, T)` is a Measure-preserving system. That is `(X, μ)` is a
`σ`-finite measure space, and `T : X → X` is an invertible bimeasurable map that is
measure preserving in the sense that `μ(T(E)) = μ(E)` for all measurable `E`.-/
variable {𝓧 : Type*} [σX : MeasurableSpace 𝓧] {μ : Measure 𝓧} [SigmaFinite μ]
  {T : 𝓧 ≃ᵐ 𝓧} (hT : MeasurePreserving T μ μ)

include hT



/- Let `P : ℤ[X]` be a polynomial with degree at least `2`. -/
variable {P : ℤ[X]} (hP : P.degree ≥ 2)

include hP

/- Let `p₁, p₂, p` be real numbers such that `1 < p₁, p₂ < ∞` and `p₁⁻¹ + p₂⁻¹ = p⁻¹ ≤ 1`. -/
variable {p₁ p₂ p : ℝ≥0∞} (h₁p₁ : 1 < p₁) (h₁p₂ : 1 < p₂) (h₂p₁ : p₁ < ∞) (h₂p₂ : p₂ < ∞)
  (hp₁p₂p : p₁⁻¹ + p₂⁻¹ = p⁻¹) (hp : p⁻¹ ≤ 1)

include h₁p₁ h₁p₂ h₂p₁ h₁p₂ h₂p₂ hp₁p₂p hp

/--
Statement of Theorem 1.17(i) (Mean ergodic theorem):

The averages `A T N X P f g` converge as `N → ∞` in `Lᵖ(X)` norm.
-/
theorem theorem_1_17_i {f g : 𝓧 → ℂ} (hf : MemLp f p₁ μ) (hg : MemLp g p₂ μ) :
    ∃ h : 𝓧 → ℂ, MemLp h p μ ∧
    Tendsto (fun N ↦ eLpNorm (A T N (X : ℤ[X]) P f g - h) p μ) atTop (𝓝 0) := Submission.PointwiseErgodicTheorems.theorem_1_17_i hT hP h₁p₁ h₁p₂ h₂p₁ h₂p₂ hp₁p₂p hp hf hg

/--
Statement of Theorem 1.16(ii) (Pointwise ergodic theorem):

The averages `A T N X P f g` converge as `N → ∞` pointwise almost everywhere.
-/
theorem theorem_1_17_ii {f g : 𝓧 → ℂ} (hf : MemLp f p₁ μ) (hg : MemLp g p₂ μ) :
    ∃ h : 𝓧 → ℂ, MemLp h p μ ∧
    ∀ᵐ x ∂μ, Tendsto (fun N ↦ A T N (X : ℤ[X]) P f g x) atTop (𝓝 (h x)) := Submission.PointwiseErgodicTheorems.theorem_1_17_ii hT hP h₁p₁ h₁p₂ h₂p₁ h₂p₂ hp₁p₂p hp hf hg

/-- The constant of Theorem 1.17 (iii). -/
@[reducible] noncomputable def Cᵢᵢᵢ (P : ℤ[X]) (p₁ p₂ : ℝ≥0∞) : ℝ≥0 := Submission.PointwiseErgodicTheorems.Cᵢᵢᵢ P p₁ p₂

/--
Statement of Theorem 1.17(iii) (Maximal ergodic theorem):

There exists a constant `C ≥ 0` such that for any `f ∈ Lᵖ₁(X)` and `g ∈ Lᵖ₂(X)`,
`‖A T (N : ℕ+) X P f g‖_{Lᵖ(X;ℓ∞)} ≤ C ‖f‖_{Lᵖ₁(X)} ‖g‖_{Lᵖ₂(X)}`.
-/
theorem theorem_1_17_iii {f g : 𝓧 → ℂ} (hf : MemLp f p₁ μ) (hg : MemLp g p₂ μ) :
    eLpNorm (fun x ↦ ⨆ (N : ℕ+), ‖A T N (X : ℤ[X]) P f g x‖ₑ) p μ ≤
      Cᵢᵢᵢ P p₁ p₂ * ‖hf.toLp‖ₑ * ‖hg.toLp‖ₑ := Submission.PointwiseErgodicTheorems.theorem_1_17_iii hT hP h₁p₁ h₁p₂ h₂p₁ h₂p₂ hp₁p₂p hp hf hg

/-- The constant of Theorem 1.17 (iv). -/
@[reducible] noncomputable def Cᵢᵥ (P : ℤ[X]) (p₁ p₂ : ℝ≥0∞) (r Λ : ℝ≥0) : ℝ≥0 := Submission.PointwiseErgodicTheorems.Cᵢᵥ P p₁ p₂ r Λ

/--
Statement of Theorem 1.17(iv) (Long variational ergodic theorem):

For any `r > 2` and `Λ > 1`, there exists a constant `C ≥ 0` such that for any `f ∈ Lᵖ₁(X)`,
`g ∈ Lᵖ₂(X)` and `Λ`-lacunary sequence `a` such that `1 ≤ a n` for all `n ∈ ℕ`,
`‖A T (a n) X P f g‖_{Lᵖ(X;Vʳ)} ≤ C ‖f‖_{Lᵖ₁(X)} ‖g‖_{Lᵖ₂(X)}`.
-/
theorem theorem_1_17_iv (r Λ : ℝ≥0) (hr : r > 2) (hΛ : Λ > 1) {f g : 𝓧 → ℂ}
    (hf : MemLp f p₁ μ) (hg : MemLp g p₂ μ) (a : ℕ → ℝ≥0) (ha : Lacunary Λ a) (ha' : ∀ n, 1 ≤ a n) :
    eLpNorm (fun x ↦ variationalNorm r fun n ↦ A T (a n) X P f g x) p μ ≤
      Cᵢᵥ P p₁ p₂ r Λ * ‖hf.toLp‖ₑ * ‖hg.toLp‖ₑ := Submission.PointwiseErgodicTheorems.theorem_1_17_iv hT hP h₁p₁ h₁p₂ h₂p₁ h₂p₂ hp₁p₂p hp r Λ hr hΛ hf hg a ha ha'

end PointwiseErgodicTheorems
