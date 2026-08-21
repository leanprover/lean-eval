/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.Analysis.Normed.Lp.MeasurableSpace
import Mathlib.Dynamics.FixedPoints.Support
import Mathlib.MeasureTheory.Measure.Haar.OfBasis
import EvalTools.Markers

/-!
# Main Statement from Proof of the simplicity conjecture

We formalise the statement of the main result from D. Cristofaro-Gardiner, V. Humilière,
and S. Seyfaddini, `Proof of the simplicity conjecture`, Annals of Math, 199 (1) 2024.
-/

set_option autoImplicit false

namespace SimplicityConjecture

open Function Homeomorph MeasureTheory

/-- `𝔻` is the closed unit disc in `ℝ²`. -/
notation "𝔻" => Metric.closedBall (0 : EuclideanSpace ℝ (Fin 2)) 1

/-- `𝔻ᵒ` is the interior of `𝔻`. -/
notation "𝔻ᵒ" => Subtype.val ⁻¹' Metric.ball (0 : EuclideanSpace ℝ (Fin 2)) 1

noncomputable instance : MeasureSpace 𝔻 := Measure.Subtype.measureSpace

/-- Area preserving homeomorphisms of `𝔻` that are the identity near the boundary. -/
def Homeo : Subgroup (𝔻 ≃ₜ 𝔻) where
  carrier := {ϕ | MeasurePreserving ϕ volume volume ∧ fixedSupport ϕ ⊆ 𝔻ᵒ}
  one_mem' := ⟨MeasurePreserving.id _, by simp [one_def, fixedSupport_def]⟩
  inv_mem' {ϕ} := .imp (.symm ϕ.toMeasurableEquiv)
    (by simp [inv_def, fixedSupport_def, ← coe_symm_toEquiv])
  mul_mem' {ϕ ψ} := fun ⟨hϕ1, hϕ2⟩ ⟨hψ1, hψ2⟩ ↦ ⟨hϕ1.comp hψ1, by
    rw [fixedSupport_def] at hϕ2 hψ2 ⊢
    have : fixedPoints ϕ ∩ fixedPoints ψ ⊆ fixedPoints (ϕ * ψ) := inter_subset_fixedPoints_comp
    grw [← this, Set.compl_inter, closure_union, hϕ2, hψ2, Set.union_self]⟩

/--
Statement of Theorem 1.2:

The group `Homeo_c(𝔻, ω)` is not simple.
-/
@[eval_problem]
theorem theorem_1_2 : ¬ IsSimpleGroup Homeo := by
  sorry

end SimplicityConjecture
