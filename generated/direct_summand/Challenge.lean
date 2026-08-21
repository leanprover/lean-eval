import Mathlib
import ChallengeDeps
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







instance {C : Type*} [Category* C] {J : GrothendieckTopology C} (R : Sheaf J RingCat) (X : Cᵒᵖ) :
    (SheafOfModules.evaluation R X).Additive where
  map_add := rfl
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
theorem direct_summand (B : Type*) [CommRing B] [Algebra A B]
    [Module.Finite A B] [FaithfulSMul A B] :
    ∃ π : B →ₗ[A] A, π ∘ₗ Algebra.linearMap A B = .id := by
  sorry

end LeanEval.AlgebraicGeometry.DirectSummand
