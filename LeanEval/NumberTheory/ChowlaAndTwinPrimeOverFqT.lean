/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.Analysis.Normed.Unbundled.RingSeminorm
import Mathlib.Analysis.SpecialFunctions.Log.Base
import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.RingTheory.Ideal.Norm.AbsNorm
import Mathlib.RingTheory.UniqueFactorizationDomain.Moebius
import EvalTools.Markers

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

/-- The norm of `f ∈ F[T]` is `|F[T]/(f)|`; see Equation (1.1) in the paper. -/
theorem norm_eq_cardQuot (f : F[X]) : ‖f‖ = (Ideal.span {f}).cardQuot := by
  rfl

/-- The norm of a nonzero `f ∈ F[T]` is `|F| ^ deg(f)`; see Equation (1.1) in the paper. -/
theorem norm_eq_pow_natDegree {f : F[X]} (hf : f ≠ 0) : ‖f‖ = Nat.card F ^ f.natDegree := by
  rw [norm_eq_cardQuot, cardQuot_span_eq_pow_natDegree hf, Nat.cast_pow]

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

/--
Statement of Theorem 1.1:

For an odd prime number `p`, and a power `q` of `p` satisfying
`q > 685090 * p ^ 2`, the following holds. For any nonzero `h ∈ 𝔽_q[T]`, we have
`#{f ∈ 𝔽_q[T] : |f| = X, f and f + h are prime} ∼ 𝔖_q(h) X / log_q^2 (X)`
as `X → ∞` through the powers of `q`.

Moreover, we have a power saving (depending on q) in the asymptotic above.
-/
@[eval_problem]
theorem theorem_1_1 (hp : Odd p) (hq : q > 685090 * p ^ 2) :
    ∃ ε > (0 : ℝ), -- there exists a power saving such that ...
      ∀ h ≠ 0, (fun X : powers q ↦ Set.ncard {f | ‖f‖ = X ∧ f ∈ primes 𝔽_q ∧ f + h ∈ primes 𝔽_q} -
        𝔖_q h * X / (Real.logb q X) ^ 2) =O[Filter.atTop] (fun X : powers q ↦ (X : ℝ) ^ (1 - ε)) :=
  sorry

variable (F) in
/-- The set of monic polynomials in `F[T]` with norm at most `X`. -/
def monicBounded (X : ℝ) : Set (F[X]) :=
  {f : F[X] | f.Monic ∧ ‖f‖ ≤ X}

/-- Euler's number `2.718...`. -/
local notation "e" => Real.exp 1

/--
Statement of Theorem 1.3:

For an odd prime number `p`, an integer `k ≥ 1`, and a power `q` of `p` satisfying `q > p²k²e²`,
the following holds. For every fixed choice of `k` distinct polynomials `h₁,...,hₖ ∈ 𝔽_q[T]`,
we have `∑ (f ∈ 𝔽_q[T]⁺, |f| ≤ X), μ(f + h₁) μ(f + h₂) ... μ(f + hₖ) = o(X)`, `X → ∞`.
-/
@[eval_problem]
theorem theorem_1_3 (hp : Odd p) (k : ℕ) (hk : k ≥ 1) (hq : q > p ^ 2 * k ^ 2 * e ^ 2)
    (h : Fin k → 𝔽_q[X]) (h_distinct : Function.Injective h) :
    (fun X : ℝ ↦ ∑' f : monicBounded 𝔽_q X, ∏ i, moebius (f + h i)) =o[Filter.atTop] id :=
  sorry

end ChowlaAndTwinPrimeOverFqT
