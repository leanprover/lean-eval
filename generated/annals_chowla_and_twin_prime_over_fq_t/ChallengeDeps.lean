import Mathlib.Analysis.Normed.Unbundled.RingSeminorm
import Mathlib.Analysis.SpecialFunctions.Log.Base
import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.RingTheory.Ideal.Norm.AbsNorm
import Mathlib.RingTheory.UniqueFactorizationDomain.Moebius
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statements from On the Chowla and twin primes conjectures over 𝔽_q[T]

We formalise the statements of the main results from W. Sawin and M. Shusterman,
`On the Chowla and twin primes conjectures over 𝔽_q[T]`, Annals of Math, 196 (2) 2022.
-/

set_option autoImplicit false

namespace ChowlaAndTwinPrimeOverFqT

open Submonoid UniqueFactorizationMonoid

open scoped Asymptotics Polynomial

variable {F : Type*} [Field F]

/-- `|F[T]/(f)| = |F| ^ deg(f)`; see Equation (1.1) in the paper. -/
theorem cardQuot_span_eq_pow_natDegree {f : F[X]} (hf : f ≠ 0) :
    (Ideal.span {f}).cardQuot = Nat.card F ^ f.natDegree := by
  have : FiniteDimensional F (F[X] ⧸ Ideal.span {f}) := (AdjoinRoot.powerBasis hf).finite
  rw [Submodule.cardQuot_apply, ← finrank_quotient_span_eq_natDegree]
  exact Module.natCard_eq_pow_finrank

variable [Finite F]

/-- `|F[T]/(f)|` defines a norm on `F[T]`; see Equation (1.1) in the paper. -/
noncomputable def ringNorm : RingNorm (F[X]) where
  toFun f := (Ideal.span {f}).cardQuot
  map_zero' := by simp
  add_le' f g := by
    norm_cast
    by_cases hf : f = 0
    · simp [hf]
    by_cases hg : g = 0
    · simp [hg]
    by_cases hfg : f + g = 0
    · simp [hfg]
    grw [cardQuot_span_eq_pow_natDegree hf, cardQuot_span_eq_pow_natDegree hg,
      cardQuot_span_eq_pow_natDegree hfg, Polynomial.natDegree_add_le f g, max_def]
    · split_ifs
      · apply self_le_add_left
      · apply self_le_add_right
    · exact Nat.card_pos
  neg' := by simp
  mul_le' f g := by
    norm_cast
    by_cases hf : f = 0
    · simp [hf]
    by_cases hg : g = 0
    · simp [hg]
    have hfg : f * g ≠ 0 := mul_ne_zero hf hg
    rw [cardQuot_span_eq_pow_natDegree hf, cardQuot_span_eq_pow_natDegree hg,
      cardQuot_span_eq_pow_natDegree hfg, Polynomial.natDegree_mul hf hg, pow_add]
  eq_zero_of_map_eq_zero' f hf := by
    contrapose! hf
    rw [cardQuot_span_eq_pow_natDegree hf, Nat.cast_ne_zero]
    exact pow_ne_zero _ Nat.card_pos.ne'

/-- The norm of `f ∈ F[T]` is defined to be `|F[T]/(f)|`; see Equation (1.1) in the paper. -/
noncomputable instance : NormedCommRing (F[X]) where
  __ := ringNorm.toNormedRing
  mul_comm := mul_comm





variable (F) in
/-- The primes of a polynomial ring are the monic irreducibles;
see the sentence after Equation (1.4) in the paper. -/
def primes : Set F[X] :=
  {P : F[X] | P.Monic ∧ Irreducible P}

/-- The norm on `F[T]` can be applied to the primes of `F[T]`. -/
noncomputable instance : Norm (primes F) where
  norm := fun ⟨P, _, _⟩ ↦ ‖P‖

open Classical in
/-- The real-valued indicator function associated to a predicate;
see Equation (1.4) in the paper. -/
noncomputable def indicator (pred : Prop) : ℝ := if pred then 1 else 0

open Classical in
/-- The Hardy-Littlewood constant associated to prime tuples of the form `{f, f + h}`;
see Equation (1.4) in the paper. -/
noncomputable def 𝔖_q (h : F[X]) : ℝ :=
  ∏' P : primes F, (1 - ‖P‖⁻¹ - ‖P‖⁻¹ * indicator (¬ (P : F[X]) ∣ h)) / (1 - ‖P‖⁻¹) ^ 2

variable {p : ℕ} [Fact p.Prime] {n : ℕ}

/-- The cardinality of the finite field `𝔽_q`. -/
local notation "q" => p ^ n
/-- The finite field of cardinality `q`. -/
local notation "𝔽_q" => GaloisField p n



variable (F) in
/-- The set of monic polynomials in `F[T]` with norm at most `X`. -/
def monicBounded (X : ℝ) : Set (F[X]) :=
  {f : F[X] | f.Monic ∧ ‖f‖ ≤ X}

/-- Euler's number `2.718...`. -/
local notation "e" => Real.exp 1



end ChowlaAndTwinPrimeOverFqT
