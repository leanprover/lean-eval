import Mathlib
import EvalTools.Markers

/-!
# Direct summand conjecture and its derived variant

Hochster's direct summand conjecture states that any finite extension of a regular
commutative ring splits as a module, which was first proved by André in 2016.
Bhatt gave a quicker proof that circumvents the perfectoid Abhyankar lemma (André's
prior work) using a quantitative form of Scholze’s Hebbarkeitssatz (the Riemann
extension theorem) for perfectoid spaces. The same idea also leads to a proof of a
derived variant of the direct summand conjecture put forth by de Jong, which states
that if A is a regular (Noetherian) ring and X ⟶ Spec A is proper and surjective,
then A ⟶ RΓ(X, 𝒪_X) splits in the derived category D(A).

## References

* Yves André, La conjecture du facteur direct, https://arxiv.org/abs/1609.00345
* Bhargav Bhatt, On the direct summand conjecture and its derived variant, https://arxiv.org/abs/1608.08882
* Linquan Ma, a short proof of the direct summand theorem via the flatness lemma, https://www.math.purdue.edu/~ma326/DSC.pdf
-/

open CategoryTheory AlgebraicGeometry

namespace LeanEval.AlgebraicGeometry.DirectSummand

variable (A : Type*) [CommRing A] [IsRegularRing A]

noncomputable def singleFunctorMapHomotopyCategory {W₁ W₂ : Type*} [Category* W₁] [Category* W₂]
    [Preadditive W₁] [Preadditive W₂] [Limits.HasZeroObject W₁] [Limits.HasZeroObject W₂]
    (F : W₁ ⥤ W₂) [F.Additive] (n : ℤ) :
    HomotopyCategory.singleFunctor W₁ n ⋙ F.mapHomotopyCategory _ ≅
    F ⋙ HomotopyCategory.singleFunctor W₂ n :=
  Functor.associator .. ≪≫ Functor.isoWhiskerLeft _ (F.mapHomotopyCategoryFactors _) ≪≫
    (Functor.associator ..).symm ≪≫
    Functor.isoWhiskerRight (HomologicalComplex.singleMapHomologicalComplex F ..) _

noncomputable def singleFunctorMapHomotopyCategoryPlus {W₁ W₂ : Type*} [Category* W₁] [Category* W₂]
    [Preadditive W₁] [Preadditive W₂] [Limits.HasZeroObject W₁] [Limits.HasZeroObject W₂]
    (F : W₁ ⥤ W₂) [F.Additive] (n : ℤ) :
    HomotopyCategory.Plus.singleFunctor W₁ n ⋙ F.mapHomotopyCategoryPlus ≅
    F ⋙ HomotopyCategory.Plus.singleFunctor W₂ n :=
  NatIso.ofComponents
    (fun X ↦ ObjectProperty.isoMk _ <| (singleFunctorMapHomotopyCategory F n).app X) <| by
    intros; ext; exact (singleFunctorMapHomotopyCategory F n).hom.naturality _

noncomputable def rightDerivedFunctorPlusUnit' {C D : Type*} [Category* C] [Category* D]
    [Abelian C] [Abelian D] [HasDerivedCategory C] [HasDerivedCategory D]
    (F : C ⥤ D) [F.Additive] [EnoughInjectives C] (n : ℤ) :
    F ⋙ DerivedCategory.Plus.singleFunctor _ n ⟶
    DerivedCategory.Plus.singleFunctor _ n ⋙ F.rightDerivedFunctorPlus :=
  Functor.whiskerRight (singleFunctorMapHomotopyCategoryPlus F n).inv DerivedCategory.Plus.Qh ≫
    (HomotopyCategory.Plus.singleFunctor _ n).whiskerLeft F.rightDerivedFunctorPlusUnit

instance {C : Type*} [Category* C] {J : GrothendieckTopology C} (R : Sheaf J RingCat) (X : Cᵒᵖ) :
    (SheafOfModules.evaluation R X).Additive where
  map_add := rfl

/-- The composite of evaluation at `⊤` with restriction of scalars is additive. Both factors
are additive, but the generic `Functor.Additive` instance for a composite does not fire at this
elaborated form, so state it directly. -/
instance (X : Scheme) {S : Type*} [Ring S] (φ : S →+* Γ(X, ⊤)) :
    (SheafOfModules.evaluation X.ringCatSheaf ⟨⊤⟩ ⋙ ModuleCat.restrictScalars φ).Additive :=
  ⟨rfl⟩

@[eval_problem]
theorem derived_direct_summand [HasDerivedCategory (ModuleCat A)]
    (X : Scheme) (f : X ⟶ Spec (.of A)) [IsProper f] (surj : Function.Surjective f)
    [HasDerivedCategory (SheafOfModules X.ringCatSheaf)] :
    let φ : A →+* Γ(X, ⊤) := ((ΓSpec.adjunction.homEquiv _ _).symm f).unop.hom
    let : Algebra A Γ(X, ⊤) := φ.toAlgebra
    ∀ _ : EnoughInjectives (SheafOfModules X.ringCatSheaf), IsSplitMono <|
      (DerivedCategory.Plus.singleFunctor _ 0).map
        (ModuleCat.ofHom (Algebra.linearMap A Γ(X, ⊤))) ≫
      (rightDerivedFunctorPlusUnit' (SheafOfModules.evaluation X.ringCatSheaf ⟨⊤⟩ ⋙
        ModuleCat.restrictScalars φ) 0).app (SheafOfModules.unit X.ringCatSheaf) := by
  sorry

@[eval_problem]
theorem direct_summand (B : Type*) [CommRing B] [Algebra A B]
    [Module.Finite A B] [FaithfulSMul A B] :
    ∃ π : B →ₗ[A] A, π ∘ₗ Algebra.linearMap A B = .id := by
  sorry

end LeanEval.AlgebraicGeometry.DirectSummand
