import Mathlib.AlgebraicGeometry.Group.Abelian
import Lake.Toml
import Lake.Util.Message
import Lean

/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning, Christian Merten
-/

import Mathlib.AlgebraicGeometry.Group.Abelian
/-!
# Main Statement from Uniformity in Mordell–Lang for curves

We formalise the statement of the main result from V. Dimitrov, Z. Gao, and P. Habegger,
`Uniformity in Mordell–Lang for curves`, Annals of Math, 194 (1) 2021.

## Implementation Details

In AnnalsChallenge this file imports `AnnalsChallenge.Definitions.AlgebraicJacobian`, Christian
Merten's Jacobian challenge, and the statement below is only meaningful once that file's sorries
are filled. LeanEval already carries a port of that file as
`LeanEval.AlgebraicGeometry.JacobianChallenge` (problem `jacobian_challenge_alggeo`), but that
port drops the four declarations at the end of the original, three of which are anonymous
instances, and one of those is what supplies the `CommGroup` structure on the `F`-points that
`freeRank` needs below.

Rather than change an existing problem, this module carries its own copy of exactly the part of
the Jacobian characterisation that Theorem 1.1 quotes: `genus`, `Jacobian`, the group scheme
structure, properness, geometric integrality, and the two instances derived from them. The copy
lives in `UniformMordellLang.JacobianChallenge` rather than `AlgebraicGeometry.JacobianChallenge`
so that it does not collide with the existing problem module when `eval_inventory` imports the
whole catalog into one environment. The statement of Theorem 1.1 itself is unchanged.
-/

set_option autoImplicit false

namespace UniformMordellLang

/-! ### The part of the Jacobian characterisation that Theorem 1.1 quotes

Copied from `AnnalsChallenge/Definitions/AlgebraicJacobian.lean`; see the module docstring. -/

namespace JacobianChallenge

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj AlgebraicGeometry

universe u

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
  -- smooth curve
  [SmoothOfRelativeDimension 1 C.hom]
  -- proper
  [IsProper C.hom]
  -- geometrically irreducible
  [GeometricallyIrreducible C.hom]

-- data
/-- The genus of a smooth proper curve. -/
def genus (C : Over (Spec (.of k))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : ℕ :=
  sorry

-- data
/-- The Jacobian of a smooth, proper curve over a field `k`. -/
def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : Over (Spec (.of k)) :=
  sorry

namespace Jacobian

/-! ## The Jacobian of `C` is an abelian variety. -/

-- data
/-- The group scheme structure on the Jacobian of the curve `C`. -/
instance instGrpObj : GrpObj (Jacobian C) :=
  sorry

set_option linter.defProp false in
/-- The Jacobian of `C` is smooth of relative dimension `g` over `k`, where `g` is the
genus of `C`. -/
@[instance_reducible, instance]
noncomputable def smoothOfRelativeDimension_genus :
    SmoothOfRelativeDimension (genus C) (Jacobian C).hom :=
  sorry

set_option linter.defProp false in
/-- The Jacobian of `C` is proper over `k`. -/
@[instance_reducible, instance]
noncomputable def instIsProper : IsProper (Jacobian C).hom :=
  sorry

set_option linter.defProp false in
/-- The Jacobian of `C` is geometrically irreducible over `k`. -/
@[instance_reducible, instance]
noncomputable def instGeometricallyIrreducible :
    GeometricallyIrreducible (Jacobian C).hom :=
  sorry

-- data
/-- The Abel-Jacobi map from a smooth, proper curve to its Jacobian associated
to a `k`-rational point of `C`. -/
def ofCurve (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : C ⟶ Jacobian C :=
  sorry

/-- The Abel-Jacobi map sends the `k`-rational point `P` to `0`, where `0` (denoted by `η` below) is
the neutral element of the group scheme `Jacobian C`. -/
theorem comp_ofCurve (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    P ≫ ofCurve P = η[Jacobian C] :=
  sorry

/--
The universal property of the Jacobian variety: For any abelian variety `A`,
any morphism `f : C ⟶ A` such that `f(P) = 0` factors uniquely through the
Jacobian of `C`.
In other words, `Jacobian C` is the Albanese variety of `C`.
-/
theorem exists_unique_ofCurve_comp (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C)
    {A : Over (Spec (.of k))} [Smooth A.hom] [IsProper A.hom] [GrpObj A]
    [GeometricallyIrreducible A.hom] (f : C ⟶ A) (hf : P ≫ f = η[A]) :
    ∃! (g : Jacobian C ⟶ A), f = ofCurve P ≫ g :=
  sorry

set_option linter.defProp false in
/-- The Jacobian of `C` is geometrically integral over `k`. -/
@[instance_reducible, instance]
noncomputable def instGeometricallyIntegral : GeometricallyIntegral (Jacobian C).hom :=
  sorry

/-- The Jacobian of `C` is an abelian variety. -/
instance instIsCommMonObj {k : Type u} [fieldK : Field k] {C : Over (Spec (.of k))}
    [smoothC : SmoothOfRelativeDimension 1 C.hom] [properC : IsProper C.hom]
    [integralC : GeometricallyIrreducible C.hom] : IsCommMonObj (Jacobian C) :=
  isCommMonObj_of_isProper_of_geometricallyIntegral (Jacobian C)

set_option warn.classDefReducibility false in
/-- The `k`-points of the Jacobian of `C` form an abelian group. -/
@[instance] noncomputable abbrev instCommGroup {k : Type u} [fieldK : Field k]
    {C : Over (Spec (.of k))} [smoothC : SmoothOfRelativeDimension 1 C.hom]
    [properC : IsProper C.hom] [integralC : GeometricallyIrreducible C.hom] :
    CommGroup (𝟙_ (Over (Spec (.of k))) ⟶ Jacobian C) :=
  @CategoryTheory.Hom.commGroup
    (Over (Spec (.of k)))
    (CategoryTheory.instCategoryOver)
    (AlgebraicGeometry.instCartesianMonoidalCategoryOverScheme)
    (Jacobian C)
    (𝟙_ (Over (Spec (.of k))))
    (instGrpObj (k := k) (C := C))
    (AlgebraicGeometry.instBraidedCategoryOverScheme)
    (instIsCommMonObj (k := k) (C := C))

set_option linter.defProp false in
/-- If `k` is a number field, then the `k`-points of the Jacobian of `C` are finitely generated.

This is the Mordell-Weil theorem; it is what gives Theorem 1.1's `ρ` a meaning. Anonymous
upstream, named here so that it can be addressed as a hole. -/
@[instance_reducible, instance]
noncomputable def instFG [NumberField k] :
    @Group.FG (𝟙_ (Over (Spec (.of k))) ⟶ Jacobian C)
      (instCommGroup (k := k) (C := C)).toGroup :=
  sorry

end Jacobian

end JacobianChallenge

/-! ### Theorem 1.1 -/

open CommGroup Module CategoryTheory MonoidalCategory AlgebraicGeometry JacobianChallenge

/-- The function `c` of Theorem 1.1 of the paper. -/
noncomputable def c (g : ℕ) (d : ℕ) : ℕ :=
  sorry

/--
Statement of Theorem 1.1:

Let `g ≥ 2` and `d ≥ 1` be integers. Then there exists a constant `c = c(g, d) ≥ 1` with the
following property. If `C` is a smooth curve of genus `g` defined over a number field `F` with
`[F : Q] ≤ d`, then `#C(F) ≤ c^(1+ρ)`, where `ρ` is the rank of `Jac(C)(F)`.

We do not give a complete definition of the Jacobian of `C`. Instead, a characterization can be
found in `UniformMordellLang.JacobianChallenge` above whose sorries must be filled.

Note however that the characterization of the Jacobian of `C` is only correct when the `C` has an
`F`-point, but Theorem 1.1 is trivial when `C` has no `F`-points, so this is not a problem.
-/
theorem theorem_1_1 (g d : ℕ) (hg : g ≥ 2) (hd : d ≥ 1) {F : Type*} [Field F] [NumberField F]
    (hF : finrank ℚ F ≤ d) (C : Over (Spec (.of F))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] (hC : genus C = g) :
    ENat.card (𝟙_ (Over (Spec (.of F))) ⟶ C) ≤
      c g d ^ (1 + freeRank (𝟙_ (Over (Spec (.of F))) ⟶ Jacobian C)) := by
  sorry

end UniformMordellLang
