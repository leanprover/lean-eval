import Mathlib
import Submission.Helpers
import ChallengeDeps
/-!
# Derived solidification of free CW complexes

This challenge is extracted from the LeanCondensed project
<https://github.com/dagurtomas/LeanCondensed>, which develops the theory of light condensed
mathematics of Clausen–Scholze in Lean.  The target statement is the comparison theorem for a CW
complex `X`: the homology of the derived solidification of the free light condensed abelian group
on `X` is integral singular homology.

The non-`sorry` part of this file develops, using only Mathlib, the definition of
*light solid abelian groups*: a light condensed abelian group `A` is solid if the map
`1 - shift` on the free light condensed abelian group `P = ℤ[ℕ∪{∞}]/ℤ[∞]` induces an isomorphism
on internal homs into `A`.  The full subcategory `Solid` of solid objects is closed under limits,
kernels, cokernels and finite products, hence abelian, and the inclusion into light condensed
abelian groups is exact, so it induces a functor on derived categories.

The `sorry`ed declarations (the holes of this multi-hole problem) are:

* `solidification` — the solidification functor `LightCondAb ⥤ Solid`;
* `solidification_additive` — additivity of the solidification functor;
* `solidificationAdjunction` — solidification is left adjoint to the inclusion;
* `derivedSolidification` — the derived solidification functor
  `DerivedCategory LightCondAb ⥤ DerivedCategory Solid`;
* `derivedSolidificationCounit` — the comparison map exhibiting `derivedSolidification` as a
  functor under degreewise solidification;
* `derivedSolidification_isLeftDerivedFunctor` — `derivedSolidification` is the total left
  derived functor of degreewise solidification;
* `derivedSolidificationAdjunction` — derived solidification is left adjoint to the derived
  inclusion;
* `derivedSolidificationFreeCWFunctor` — the functor on CW complexes whose values are the derived
  inclusion of the derived solidification of the free light condensed abelian group;
* `derivedSolidificationFreeCWFunctorSpec` — an isomorphism identifying
  `derivedSolidificationFreeCWFunctor` with the expected composite functor;
* `derivedSolidification_free_CW_derivedNatIso` — naturally in a CW complex `X`, the derived
  inclusion of the derived solidification of `ℤ[X]` is isomorphic in the derived category of light
  condensed abelian groups to the integral singular chain complex of `X`, viewed as a complex of
  discrete light condensed abelian groups with homological degree `n` placed in cohomological
  degree `-n`, this is the main challenge;
* `derivedSolidification_free_CW_homologyIso` — for a CW complex `X`, the homology of the derived
  solidification of `ℤ[X]` is integral singular homology (the derived category is cohomologically
  indexed, so the `n`-th singular homology group appears in degree `-n`);
* `derivedSolidification_free_CW_homology` — the theorem form of the previous isomorphism.

All holes must be filled compatibly: the adjunctions and derived functor property pin down
`solidification` and `derivedSolidification` up to natural isomorphism, so the final derived
comparison theorem and its pointwise homology form have their intended mathematical content.

Note that the LeanCondensed project contains significant progress towards some of the earlier holes
in this challenge.
-/


namespace Submission

open _root_.LightCondensed
open _root_.LightCondensed.Solid
open _root_.LightCondensed.Solid.CWTopCat
open _root_.LightProfinite
open CategoryTheory Limits LightProfinite OnePoint LightCondensed MonoidalCategory MonoidalClosed

noncomputable section

namespace LightProfinite



end LightProfinite

namespace LightCondensed



























/-- The class expressing that a light condensed abelian group is solid. -/
abbrev IsSolid (A : LightCondAb) := isSolid.Is A



namespace Solid



































/-- **Hole 1.** The solidification functor, left adjoint to the inclusion of solid objects. -/
def solidification : LightCondAb ⥤ Solid := sorry

/-- **Hole 2.** The solidification functor is additive.  (This follows from the adjunction of the
next hole, but is needed as an instance to state the holes below.) -/
instance solidification_additive : solidification.Additive := sorry

/-- **Hole 3.** The solidification adjunction: solidification is left adjoint to the inclusion of
solid objects in light condensed abelian groups. -/
def solidificationAdjunction : solidification ⊣ isSolid.ι := sorry

/-- **Hole 4.** The derived solidification functor. -/
def derivedSolidification : DLightCondAb ⥤ DSolid := sorry

/-- **Hole 5.** The comparison map from derived solidification to degreewise solidification. -/
def derivedSolidificationCounit :
    DerivedCategory.Q ⋙ derivedSolidification ⟶
      solidification.mapHomologicalComplex (ComplexShape.up ℤ) ⋙ DerivedCategory.Q := sorry

/-- **Hole 6.** Derived solidification, together with the comparison map of the previous hole, is
the total left derived functor of degreewise solidification followed by localization. -/
instance derivedSolidification_isLeftDerivedFunctor :
    derivedSolidification.IsLeftDerivedFunctor derivedSolidificationCounit
      (HomologicalComplex.quasiIso LightCondAb (ComplexShape.up ℤ)) := sorry

/-- The inclusion of solid abelian groups, applied degreewise to cochain complexes. -/
abbrev inclusionComplexes :
    CochainComplex Solid ℤ ⥤ CochainComplex LightCondAb ℤ :=
  isSolid.ι.mapHomologicalComplex (ComplexShape.up ℤ)



/-- The derived inclusion is induced by applying the inclusion degreewise to complexes. -/
abbrev derivedInclusionFactors :
    DerivedCategory.Q ⋙ derivedInclusion ≅ inclusionComplexes ⋙ DerivedCategory.Q :=
  isSolid.ι.mapDerivedCategoryFactors

/-- The comparison map exhibiting `derivedInclusion` as a right derived functor of the degreewise
inclusion. -/
abbrev derivedInclusionComparison :
    inclusionComplexes ⋙ DerivedCategory.Q ⟶ DerivedCategory.Q ⋙ derivedInclusion :=
  derivedInclusionFactors.inv

/-- The exact derived inclusion is the right derived functor of the degreewise inclusion. -/
instance derivedInclusion_isRightDerivedFunctor :
    derivedInclusion.IsRightDerivedFunctor derivedInclusionComparison
      (HomologicalComplex.quasiIso Solid (ComplexShape.up ℤ)) :=
  Functor.isRightDerivedFunctor_of_inverts
    (HomologicalComplex.quasiIso Solid (ComplexShape.up ℤ)) derivedInclusion
    derivedInclusionFactors

/-- **Hole 7.** The derived solidification adjunction: derived solidification is left adjoint to
the derived inclusion. -/
def derivedSolidificationAdjunction : derivedSolidification ⊣ derivedInclusion :=
  sorry











/-- The integral singular chain complex of a topological space as a derived object. -/
abbrev singularChainsLightCondAbDerived (X : TopCat) : DLightCondAb :=
  singularChainsLightCondAbDerivedFunctor.obj X





namespace CWTopCat

instance (X : CWTopCat) : Topology.CWComplex (Set.univ : Set X.obj) :=
  Classical.choice X.property



end CWTopCat

/-- **Hole 8.** The functor sending a CW complex to the derived inclusion of the derived
solidification of the free light condensed abelian group on it. -/
def derivedSolidificationFreeCWFunctor : CWTopCat ⥤ DLightCondAb := sorry

/-- **Hole 9.** The specification identifying `derivedSolidificationFreeCWFunctor` with the
expected composite functor. -/
def derivedSolidificationFreeCWFunctorSpec :
    derivedSolidificationFreeCWFunctor ≅
      CWTopCat.toTopCat ⋙ freeLightCondAbOfTopFunctor ⋙ DerivedCategory.singleFunctor LightCondAb 0 ⋙
        derivedSolidification ⋙ derivedInclusion := sorry



/-- **Hole 10.** The derived comparison theorem, naturally in a CW complex `X`: after applying the
exact derived inclusion from solid light condensed abelian groups to light condensed abelian groups,
the derived solidification of the free light condensed abelian group on `X` is the integral singular
chain complex of `X` as a derived object of light condensed abelian groups. -/
def derivedSolidification_free_CW_derivedNatIso :
    derivedSolidificationFreeCWFunctor ≅ singularChainsLightCondAbCWDerivedFunctor := sorry

/-- The pointwise component of `derivedSolidification_free_CW_derivedNatIso`. -/
def derivedSolidification_free_CW_derivedIso
    (X : TopCat) [Topology.CWComplex (Set.univ : Set X)] :
    derivedInclusion.obj
      (derivedSolidification.obj
        ((DerivedCategory.singleFunctor LightCondAb 0).obj (freeLightCondAbOfTop X))) ≅
      singularChainsLightCondAbDerived X :=
  (derivedSolidificationFreeCWFunctorSpec.app ⟨X, ⟨inferInstance⟩⟩).symm.trans
    (derivedSolidification_free_CW_derivedNatIso.app ⟨X, ⟨inferInstance⟩⟩)

/-- **Hole 11.** For a CW complex `X`, the homology of the derived solidification of the free
light condensed abelian group on `X` is integral singular homology.  Since the derived category
is cohomologically indexed, the `n`-th singular homology group occurs in degree `-n`. -/
def derivedSolidification_free_CW_homologyIso
    (X : TopCat) [Topology.CWComplex (Set.univ : Set X)] (n : ℕ) :
    isSolid.ι.obj
      ((DerivedCategory.homologyFunctor Solid (-(n : ℤ))).obj
        (derivedSolidification.obj
          ((DerivedCategory.singleFunctor LightCondAb 0).obj (freeLightCondAbOfTop X)))) ≅
      singularHomologyLightCondAb X n := sorry

/-- **Hole 12.** The theorem form of `derivedSolidification_free_CW_homologyIso`: the derived
solidification of the free light condensed abelian group on a CW complex computes integral
singular homology. -/
theorem derivedSolidification_free_CW_homology
    (X : TopCat) [Topology.CWComplex (Set.univ : Set X)] (n : ℕ) :
    Nonempty
      (isSolid.ι.obj
        ((DerivedCategory.homologyFunctor Solid (-(n : ℤ))).obj
          (derivedSolidification.obj
            ((DerivedCategory.singleFunctor LightCondAb 0).obj (freeLightCondAbOfTop X)))) ≅
        singularHomologyLightCondAb X n) := sorry

end Solid

end LightCondensed

end

end Submission
