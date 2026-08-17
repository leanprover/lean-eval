/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.Algebra.Lie.OfAssociative
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.AlgebraicGeometry.IdealSheaf.IrreducibleComponent
import Mathlib.NumberTheory.NumberField.Discriminant.Basic
import EvalTools.Markers

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

/--
Statement of Theorem 1 (Number fields have small models):

There exists a positive constant `Q` such that the following is true. Let `K` be a number field
of degree `n ≥ Q` and root discriminant `δ` over `ℚ`. Then there exist integers `r ≤ Q log n` and
`d ≤ Q log n` such that `(d + r) choose r ≤ Q n log n`, and there exist `r` polynomials
`E₁, ..., Eᵣ` of degree `≤ d` in `ℤ[x₁, ..., xᵣ]` all having coefficients bounded in absolute value
by `(n δ) ^ (Q log n)` such that the (smooth and zero-dimensional affine) scheme with equations
`E₁ = ... = Eᵣ = 0` and `det (∂Eᵢ/∂xⱼ) ≠ 0` contains `Spec K` as one of its irreducible components.
-/
@[eval_problem]
theorem theorem_1 : ∃ Q > 0, ∀ n ≥ Q, ∀ K : NumberFieldOfDegree n, ∃ (r d : ℕ),
    r ≤ Q * log n ∧ d ≤ Q * log n ∧ (d + r).choose r ≤ Q * n * log n ∧
      ∃ E : Fin r → MvPolynomial (Fin r) ℤ, (∀ i, (E i).totalDegree ≤ d) ∧
        (∀ i j, |(E i).coeff j| ≤ (n * rootDiscr K) ^ (Q * log n)) ∧
          letI X := nonsingularOpen fun i ↦ (E i).map (algebraMap ℤ ℚ)
          ∃ Z, ∃ hZ : Z ∈ irreducibleComponents X,
            Nonempty (X.irreducibleComponent Z hZ ≅ Spec (.of K)) := by
  sorry

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

/--
Statement of Theorem 2 (Number fields with bounded discriminant):

There exists a positive constant `Q` such that the following is true. Let `n ≥ Q` be an integer.
Let `H ≥ 1` be an integer. The number of isomorphism classes of number fields
with degree `n` and discriminant `≤ H` is `≤ n^(Q n log^3 n) H^(Q log^3 n)`.
-/
@[eval_problem]
theorem theorem_2 : ∃ Q > 0, ∀ n ≥ Q, ∀ H ≥ 1,
    (Nat.card (NumberFieldOfBoundedDiscriminantUpToIsomorphism n H) : ℝ) ≤
      n ^ (Q * n * log n ^ 3) * H ^ (Q * log n ^ 3) := by
  sorry

end theorem_2

end EnumeratingNumberFields
