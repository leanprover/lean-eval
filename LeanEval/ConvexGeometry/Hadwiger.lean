import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace ConvexGeometry

/-!
# Hadwiger's theorem

§31 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. The real
vector space of continuous, rigid-motion-invariant valuations on convex
bodies in `ℝⁿ` has dimension `n + 1` (a basis being the intrinsic volumes,
the coefficients of the Steiner polynomial `Vol(K + tB)`).

mathlib has `ConvexBody V` with its Hausdorff `MetricSpace`, but no
valuations on convex bodies, no intrinsic volumes, and no Hadwiger's
theorem; a search found no formalization of it in any other proof assistant.
The problem defines the `IsValuation` predicate and the `valuations`
submodule.

The additivity clause is stated over four convex bodies `A B C D` with
`↑A = ↑C ∪ ↑D`, `↑B = ↑C ∩ ↑D`; when `C ∩ D` is empty no body `B` exists
and that case is dropped (mathlib's `ConvexBody` is nonempty).
-/

open scoped Classical

/-- The model space `ℝⁿ`. -/
abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- A continuous, rigid-motion-invariant, additive real valuation on the
convex bodies of `ℝⁿ`: continuity in the Hausdorff metric, inclusion–
exclusion additivity, and invariance under linear isometries and
translations. -/
def IsValuation {n : ℕ} (f : ConvexBody (E n) → ℝ) : Prop :=
  Continuous f ∧
  (∀ A B C D : ConvexBody (E n),
      (A : Set (E n)) = (C : Set (E n)) ∪ (D : Set (E n)) →
      (B : Set (E n)) = (C : Set (E n)) ∩ (D : Set (E n)) →
      f A + f B = f C + f D) ∧
  (∀ A B : ConvexBody (E n), ∀ e : E n ≃ₗᵢ[ℝ] E n,
      (B : Set (E n)) = e '' (A : Set (E n)) → f B = f A) ∧
  (∀ A B : ConvexBody (E n), ∀ t : E n,
      (B : Set (E n)) = (· + t) '' (A : Set (E n)) → f A = f B)

/-- The valuations form an `ℝ`-subspace of `ConvexBody ℝⁿ → ℝ`. -/
noncomputable def valuations (n : ℕ) : Submodule ℝ (ConvexBody (E n) → ℝ) where
  carrier := {f | IsValuation f}
  add_mem' := by
    rintro f g ⟨hfc, hfa, hfi, hft⟩ ⟨hgc, hga, hgi, hgt⟩
    refine ⟨hfc.add hgc, fun A B C D hU hI => ?_, fun A B e hB => ?_, fun A B t hB => ?_⟩
    · have h₁ := hfa A B C D hU hI
      have h₂ := hga A B C D hU hI
      simp only [Pi.add_apply]
      linarith
    · simp only [Pi.add_apply, hfi A B e hB, hgi A B e hB]
    · simp only [Pi.add_apply, hft A B t hB, hgt A B t hB]
  zero_mem' :=
    ⟨continuous_zero, fun _ _ _ _ _ _ => rfl, fun _ _ _ _ => rfl, fun _ _ _ _ => rfl⟩
  smul_mem' := by
    rintro c f ⟨hfc, hfa, hfi, hft⟩
    refine ⟨hfc.const_smul c, fun A B C D hU hI => ?_, fun A B e hB => ?_, fun A B t hB => ?_⟩
    · have h := hfa A B C D hU hI
      simp only [Pi.smul_apply]
      rw [← smul_add, ← smul_add, h]
    · simp only [Pi.smul_apply, hfi A B e hB]
    · simp only [Pi.smul_apply, hft A B t hB]

/-- **Hadwiger's theorem.** The space of continuous rigid-motion-invariant
valuations on convex bodies in `ℝⁿ` is `(n+1)`-dimensional. -/
@[eval_problem]
theorem hadwiger (n : ℕ) : Module.finrank ℝ (valuations n) = n + 1 := by
  sorry

end ConvexGeometry
end LeanEval
