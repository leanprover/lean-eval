/-
Copyright (c) 2026 Kim Morrison. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kim Morrison
-/
import Mathlib
import EvalTools.Markers

/-!
# Abelian varieties not dominated by low-dimensional Jacobians

Jacob Tsimerman proved that, for every `g ≥ 4`, there is a `g`-dimensional
abelian variety over `ℚ̄` which is not a quotient of the Jacobian of any curve
of genus at most `2g - 1`.

Mathlib does not yet bundle abelian varieties or construct Jacobians. We give
both notions their standard scheme-theoretic meanings here:

* an `AbelianVariety g` is a smooth proper geometrically irreducible
  commutative group scheme of relative dimension `g`;
* `IsJacobian C J` is the pointed Albanese universal property, explicitly
  quantifying over maps from `C` into every abelian variety;
* a quotient is witnessed by a morphism of group objects whose underlying
  morphism of schemes is surjective.

Using the universal property rather than importing the declarations in
`AlgebraicGeometry.JacobianChallenge` keeps this problem standalone. Those
declarations are themselves holes in a separate eval problem; treating them as
trusted constants here would not give an independently specified Jacobian.

The use of pointed curves loses no generality over `ℚ̄`: every nonempty
finite-type scheme over an algebraically closed field has a rational closed
point. The dimension of `J` is used in place of a separate genus definition,
since the Jacobian of a smooth proper geometrically irreducible curve has
dimension equal to its genus.

Reference: Jacob Tsimerman, *Abelian varieties are not quotients of
low-dimension Jacobians*, arXiv:2302.05860, Theorem 1.
-/

set_option autoImplicit false

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
open _root_.AlgebraicGeometry

namespace LeanEval
namespace AlgebraicGeometry

/-- A fixed algebraic closure of `ℚ`, used as the base field. -/
abbrev Qbar := AlgebraicClosure ℚ

/-- A `g`-dimensional abelian variety over `ℚ̄`: a smooth proper geometrically
irreducible commutative group scheme of relative dimension `g`. -/
structure AbelianVariety (g : ℕ) where
  /-- The underlying scheme over `Spec ℚ̄`. -/
  toScheme : Over (Spec (.of Qbar))
  [commGrpObj : CommGrpObj toScheme]
  [proper : IsProper toScheme.hom]
  [geometricallyIrreducible : GeometricallyIrreducible toScheme.hom]
  [smoothOfRelativeDimension : SmoothOfRelativeDimension g toScheme.hom]

attribute [instance] AbelianVariety.commGrpObj AbelianVariety.proper
  AbelianVariety.geometricallyIrreducible AbelianVariety.smoothOfRelativeDimension

/-- A pointed smooth proper geometrically irreducible curve over `ℚ̄`. -/
structure PointedCurve where
  /-- The underlying scheme over `Spec ℚ̄`. -/
  toScheme : Over (Spec (.of Qbar))
  [proper : IsProper toScheme.hom]
  [smoothOfRelativeDimension : SmoothOfRelativeDimension 1 toScheme.hom]
  [geometricallyIrreducible : GeometricallyIrreducible toScheme.hom]
  /-- The chosen `ℚ̄`-point. -/
  point : 𝟙_ (Over (Spec (.of Qbar))) ⟶ toScheme

attribute [instance] PointedCurve.proper PointedCurve.smoothOfRelativeDimension
  PointedCurve.geometricallyIrreducible

/-- `J` is the Jacobian of the pointed curve `C` when there is an Abel-Jacobi
map satisfying the pointed Albanese universal property: every pointed map from
`C` to an abelian variety factors uniquely through it by a homomorphism of
group schemes. -/
def IsJacobian {g : ℕ} (C : PointedCurve) (J : AbelianVariety g) : Prop :=
  ∃ ofCurve : C.toScheme ⟶ J.toScheme,
    C.point ≫ ofCurve = η[J.toScheme] ∧
      ∀ {d : ℕ} (A : AbelianVariety d) (f : C.toScheme ⟶ A.toScheme),
        C.point ≫ f = η[A.toScheme] →
          ∃! φ : Grp.mk J.toScheme ⟶ Grp.mk A.toScheme,
            f = ofCurve ≫ φ.hom.hom

/-- **Tsimerman's low-dimensional Jacobian quotient theorem.**

For every `g ≥ 4`, some `g`-dimensional abelian variety over `ℚ̄` is not the
quotient of the Jacobian of any curve whose Jacobian has dimension at most
`2g - 1` (equivalently, whose genus is at most `2g - 1`). Surjectivity is the
scheme-theoretic condition on the underlying map of a group-scheme
homomorphism. -/
@[eval_problem]
theorem tsimerman_not_quotient_low_dim_jacobian (g : ℕ) (hg : 4 ≤ g) :
    ∃ A : AbelianVariety g,
      ∀ (g' : ℕ), g' ≤ 2 * g - 1 →
        ∀ (C : PointedCurve) (J : AbelianVariety g'),
          IsJacobian C J →
            ¬ ∃ φ : Grp.mk J.toScheme ⟶ Grp.mk A.toScheme,
              Surjective φ.hom.hom.left := by
  sorry

end AlgebraicGeometry
end LeanEval
