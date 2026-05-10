import Mathlib.FieldTheory.IntermediateField.Adjoin.Defs
import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.RingTheory.AlgebraicIndependent.Basic
import Mathlib.RingTheory.DiscreteValuationRing.Basic
import Mathlib.RingTheory.Valuation.ValuationSubring
import Mathlib.Topology.Algebra.RestrictedProduct.Basic
import EvalTools.Markers

/-!
# Function fields of one variable

This file develops the basic theory of function fields of one variable following [Stichtenoth], with
several sorries left as LeanEval problems, and ends with a very hard sorry (Faltings' theorem).

[Stichtenoth] Henning Stichtenoth, *Algebraic Function Fields and Codes*, Second Edition.
-/

section ValuationSubalgebra

variable (R F : Type*) [CommSemiring R] [Field F] [Algebra R F]

@[ext] structure ValuationSubalgebra extends Subalgebra R F, ValuationSubring F

end ValuationSubalgebra

variable (K F: Type*) [Field K] [Field F] [Algebra K F]

namespace Algebra

class Is1DFunctionField : Prop where
  trdeg_eq_one : trdeg K F = 1
  fg : (⊤ : IntermediateField K F).FG

open scoped IntermediateField

@[eval_problem]
theorem Is1DFunctionField.finiteDimensional_of_transcendental [Is1DFunctionField K F]
    (x : F) (hx : Transcendental K x) : FiniteDimensional K⟮x⟯ F := by
  sorry

variable {K F} in
/-- The definition `Is1DFunctionField` is equivalent to [Stichtenoth, Definition 1.1.1]. -/
@[eval_problem]
theorem is1DFunctionField_iff_exists_transcendental_finiteDimensional :
    Is1DFunctionField K F ↔ ∃ x : F, Transcendental K x ∧ FiniteDimensional K⟮x⟯ F := by
  sorry

namespace Is1DFunctionField

/-- The type of places of a 1-dimensional function field. See [Stichtenoth,
Definition 1.1.4 and 1.1.8]. We omit the condition `toSubalgebra ≠ ⊥` since it is automatic. -/
@[ext] structure Place extends ValuationSubalgebra K F where
  ne_top : toSubalgebra ≠ ⊤

instance : SetLike (Place K F) F where
  coe v := v.carrier
  coe_injective' _ _ := Place.ext

instance : SMulMemClass (Place K F) K F where
  smul_mem {v} r _ h := v.smul_mem h r

instance : SubringClass (Place K F) F where
  mul_mem {v} := v.mul_mem
  one_mem {v} := v.one_mem
  add_mem {v} := v.add_mem
  zero_mem {v} := v.zero_mem
  neg_mem {v} := v.toValuationSubring.neg_mem _

variable (v : Place K F)

instance : HasMemOrInvMem v where
  mem_or_inv_mem := v.mem_or_inv_mem'

instance : Algebra v F := inferInstanceAs (Algebra v.toSubalgebra F)
instance : IsScalarTower K v F := inferInstanceAs (IsScalarTower K v.toSubalgebra F)
instance : IsFractionRing v F := inferInstanceAs (IsFractionRing v.toValuationSubring F)
instance : ValuationRing v := inferInstanceAs (ValuationRing v.toValuationSubring)

variable {K F} in
/-- [Stichtenoth, Theorem 1.1.6]. -/
@[eval_problem]
instance Place.isDiscreteValuationRing [Is1DFunctionField K F] : IsDiscreteValuationRing v := by
  sorry

variable {F} in
/-- [Stichtenoth, Corollary 1.3.4] (finitely many poles). -/
@[eval_problem]
theorem Place.finite_setOf_notMem [Is1DFunctionField K F] (x : F) :
    Finite {v : Place K F | x ∉ v} := by
  sorry

open scoped RestrictedProduct

/-- [Stichtenoth, Definition 1.5.2]. -/
abbrev Adele : Type _ := Πʳ v : Place K F, [F, v]

variable {F} in
/-- The principal adele associated to an element in the function field. -/
def Adele.principal [Is1DFunctionField K F] : F →+* Adele K F where
  toFun x := ⟨fun _ ↦ x, Place.finite_setOf_notMem K x⟩
  map_one' := rfl
  map_mul' _ _ := rfl
  map_zero' := rfl
  map_add' _ _ := rfl

instance [Is1DFunctionField K F] : Algebra F (Adele K F) where
  smul x a := ⟨x • a, (.principal K x * a).2⟩
  algebraMap := Adele.principal K
  commutes' _ _ := mul_comm ..
  smul_def' _ _ := rfl

-- TODO: generalize this to RestrictedProduct
instance : Algebra K (Adele K F) where
  __ : Module K _ := inferInstance
  algebraMap.toFun x := ⟨fun _ ↦ algebraMap K F x, .of_forall fun _ ↦ algebraMap_mem ..⟩
  algebraMap.map_one' := by ext; exact (algebraMap K F).map_one
  algebraMap.map_mul' _ _ := by ext; exact (algebraMap K F).map_mul ..
  algebraMap.map_add' _ _ := by ext; exact (algebraMap K F).map_add ..
  algebraMap.map_zero' := by ext; exact (algebraMap K F).map_zero
  commutes' _ _ := mul_comm ..
  smul_def' _ _ := by ext; apply smul_def

instance [Is1DFunctionField K F] : IsScalarTower K F (Adele K F) :=
  .of_algebraMap_eq fun _ ↦ rfl

/-- The $K$-subspace $\mathcal{A}_F(0)$, see [Stichtenoth, Definition 1.5.3]. -/
def integralAdele : Submodule K (Adele K F) where
  carrier := {x | ∀ v, x v ∈ v}
  add_mem' h₁ h₂ v := add_mem (h₁ v) (h₂ v)
  zero_mem' _ := zero_mem _
  smul_mem' _ _ h v := v.smul_mem (h v) _

/-- The genus of a function field, [Stichtenoth, Corollary 1.5.5]. -/
noncomputable def genus [Is1DFunctionField K F] : ℕ := Module.finrank K
  (Adele K F ⧸ integralAdele K F ⊔ (IsScalarTower.toAlgHom K F _).toLinearMap.range)

/-- Every function field of genus at least 2 (equivalently, every curve of geometric genus at least 2)
over a number field has only finitely many rational points. -/
@[eval_problem]
theorem faltings [NumberField K] [Is1DFunctionField K F] (h : 2 ≤ genus K F) :
    Finite {v : Place K F | Module.rank K (IsLocalRing.ResidueField v) = 1} := by
  sorry

end Is1DFunctionField

end Algebra
