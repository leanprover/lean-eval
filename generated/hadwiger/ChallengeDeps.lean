import Mathlib

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
and that case is dropped (mathlib's `ConvexBody` is nonempty). The
`Submodule` membership-closure fields of `valuations` are left as `sorry`
(routine: valuations are closed under sum and scalar multiple).
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
  add_mem' := by sorry
  zero_mem' := by sorry
  smul_mem' := by sorry



end ConvexGeometry
end LeanEval
