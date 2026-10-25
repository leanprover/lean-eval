import Mathlib
import EvalTools.Markers

/-!
# Hurwitz's 84(g-1) theorem

The number of automorphisms of a compact Riemann surface of genus g > 1 does not
exceed 84(g-1).

https://en.wikipedia.org/wiki/Hurwitz's_automorphisms_theorem
-/

namespace LeanEval.Geometry.HurwitzAutomorphism

section AlgebraicTopology

open AlgebraicTopology CategoryTheory

universe u in
instance : Limits.HasCoproducts.{u} AddCommGrpCat.{u} := inferInstance

variable (n : ℕ) (X : Type*) [TopologicalSpace X] (G : Type) [AddCommGroup G]

noncomputable abbrev singularHomology :=
  ((singularHomologyFunctor AddCommGrpCat n).obj (.of (ULift G))).obj (.of X)

noncomputable def bettiNumber : ℕ := Module.finrank ℤ <| singularHomology n X ℤ

noncomputable def genus : ℕ := bettiNumber 1 X / 2

end AlgebraicTopology

/-- The model for Riemann surfaces. -/
noncomputable abbrev mℂ := modelWithCornersSelf ℂ ℂ

@[eval_problem]
theorem hurwitz_automorphism {X : Type*} [TopologicalSpace X] [T2Space X] [ConnectedSpace X]
    [CompactSpace X] [ChartedSpace ℂ X] [IsManifold mℂ 1 X] (h : 1 < genus X) :
    ENat.card (Diffeomorph mℂ mℂ X X 1) ≤ 84 * (genus X - 1) := by
  sorry

end LeanEval.Geometry.HurwitzAutomorphism
