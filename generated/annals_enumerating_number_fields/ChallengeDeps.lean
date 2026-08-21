import Mathlib.Algebra.Lie.OfAssociative
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.AlgebraicGeometry.IdealSheaf.IrreducibleComponent
import Mathlib.NumberTheory.NumberField.Discriminant.Basic
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statements from Enumerating number fields

We formalise the statements of the main results from J.-M. Couveignes,
`Enumerating number fields`, Annals of Math, 192 (2) 2020.
-/

set_option autoImplicit false

namespace EnumeratingNumberFields

open AlgebraicGeometry Module NumberField Real Scheme

section theorem_1

/-- The type of all number fields of degree `= n`. -/
structure NumberFieldOfDegree (n : ℕ) where
  /-- The elements of the number field. -/
  carrier : Type
  /-- The field structure of the number field. -/
  field : Field carrier
  numberField : NumberField carrier
  degree : finrank ℚ carrier = n

instance (n : ℕ) : CoeSort (NumberFieldOfDegree n) Type :=
  ⟨fun F ↦ F.carrier⟩

instance (n : ℕ) (F : NumberFieldOfDegree n) : Field F :=
  F.field

instance (n : ℕ) (F : NumberFieldOfDegree n) : NumberField F :=
  F.numberField

noncomputable section

variable {r : ℕ} (E : Fin r → MvPolynomial (Fin r) ℚ)

/-- The quotient ring `ℚ[x₁,…,xᵣ]/(E₁,…,Eᵣ)`. -/
def quotientRing : Type :=
  (MvPolynomial (Fin r) ℚ) ⧸ Ideal.span (Set.range E)
deriving CommRing, IsNoetherianRing

/-- The element `det (∂Eᵢ/∂xⱼ)` of the quotient ring `ℚ[x₁,…,xᵣ]/(E₁,…,Eᵣ)`. -/
def jacobian : quotientRing E :=
  Ideal.Quotient.mk _ <| Matrix.det <| fun i j ↦ MvPolynomial.pderiv j (E i)

/-- The open subscheme of `Spec ℚ[x₁,…,xᵣ]/(E₁,…,Eᵣ)` defined by `det (∂Eᵢ/∂xⱼ) ≠ 0`. -/
def nonsingularOpen : Scheme :=
  (Spec (.of (quotientRing E))).basicOpen <|
    (ΓSpecIso _).symm.commRingCatIsoToRingEquiv <| jacobian E
deriving IsAffine

set_option backward.isDefEq.respectTransparency false in
instance : IsNoetherian (nonsingularOpen E) := by
  rw [isNoetherian_iff]
  refine ⟨?_, (nonsingularOpen E).compactSpace_of_isAffine⟩
  suffices IsLocallyNoetherian (Spec (.of (quotientRing E))) from
    isLocallyNoetherian_of_isOpenImmersion (Opens.ι _)
  rw [isLocallyNoetherian_Spec]
  infer_instance

end



end theorem_1

section theorem_2

/-- The type of all number fields of degree `n` and discriminant `≤ H`. -/
structure NumberFieldOfBoundedDiscriminant (n H : ℕ) extends NumberFieldOfDegree n where
  discr : |discr carrier| ≤ H

instance (n H : ℕ) : CoeSort (NumberFieldOfBoundedDiscriminant n H) Type :=
  ⟨fun F ↦ F.carrier⟩

instance (n H : ℕ) (F : NumberFieldOfBoundedDiscriminant n H) : Field F :=
  F.field

/-- The relation of two number fields being isomorphic. -/
def NumberFieldOfBoundedDiscriminant.iso (n H : ℕ) (K L : NumberFieldOfBoundedDiscriminant n H) :=
  Nonempty (K ≃+* L)

/-- The type of all number fields of degree `n` and discriminant `≤ H`, up to isomorphism. -/
def NumberFieldOfBoundedDiscriminantUpToIsomorphism (n H : ℕ) :=
  Quot (NumberFieldOfBoundedDiscriminant.iso n H)



end theorem_2

end EnumeratingNumberFields
