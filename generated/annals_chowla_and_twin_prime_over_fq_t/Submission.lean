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
import Submission.Helpers
import ChallengeDeps
/-!
# Main Statements from On the Chowla and twin primes conjectures over 𝔽_q[T]

We formalise the statements of the main results from W. Sawin and M. Shusterman,
`On the Chowla and twin primes conjectures over 𝔽_q[T]`, Annals of Math, 196 (2) 2022.
-/


namespace Submission

open _root_.ChowlaAndTwinPrimeOverFqT
set_option autoImplicit false

namespace ChowlaAndTwinPrimeOverFqT

open Submonoid UniqueFactorizationMonoid

open scoped Asymptotics Polynomial

variable {F : Type*} [Field F]



variable [Finite F]





/-- The norm of `f ∈ F[T]` is `|F[T]/(f)|`; see Equation (1.1) in the paper. -/
theorem norm_eq_cardQuot (f : F[X]) : ‖f‖ = (Ideal.span {f}).cardQuot := by
  rfl

/-- The norm of a nonzero `f ∈ F[T]` is `|F| ^ deg(f)`; see Equation (1.1) in the paper. -/
theorem norm_eq_pow_natDegree {f : F[X]} (hf : f ≠ 0) : ‖f‖ = Nat.card F ^ f.natDegree := by
  rw [norm_eq_cardQuot, cardQuot_span_eq_pow_natDegree hf, Nat.cast_pow]









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
theorem theorem_1_1 (hp : Odd p) (hq : q > 685090 * p ^ 2) :
    ∃ ε > (0 : ℝ), -- there exists a power saving such that ...
      ∀ h ≠ 0, (fun X : powers q ↦ Set.ncard {f | ‖f‖ = X ∧ f ∈ primes 𝔽_q ∧ f + h ∈ primes 𝔽_q} -
        𝔖_q h * X / (Real.logb q X) ^ 2) =O[Filter.atTop] (fun X : powers q ↦ (X : ℝ) ^ (1 - ε)) :=
  sorry



/-- Euler's number `2.718...`. -/
local notation "e" => Real.exp 1

/--
Statement of Theorem 1.3:

For an odd prime number `p`, an integer `k ≥ 1`, and a power `q` of `p` satisfying `q > p²k²e²`,
the following holds. For every fixed choice of `k` distinct polynomials `h₁,...,hₖ ∈ 𝔽_q[T]`,
we have `∑ (f ∈ 𝔽_q[T]⁺, |f| ≤ X), μ(f + h₁) μ(f + h₂) ... μ(f + hₖ) = o(X)`, `X → ∞`.
-/
theorem theorem_1_3 (hp : Odd p) (k : ℕ) (hk : k ≥ 1) (hq : q > p ^ 2 * k ^ 2 * e ^ 2)
    (h : Fin k → 𝔽_q[X]) (h_distinct : Function.Injective h) :
    (fun X : ℝ ↦ ∑' f : monicBounded 𝔽_q X, ∏ i, moebius (f + h i)) =o[Filter.atTop] id :=
  sorry

end ChowlaAndTwinPrimeOverFqT

end Submission
