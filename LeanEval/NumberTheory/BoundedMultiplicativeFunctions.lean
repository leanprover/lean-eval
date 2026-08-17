/-
Copyright (c) 2026 David Ledvinka. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Ledvinka
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.NumberTheory.ArithmeticFunction.Liouville
import Mathlib.NumberTheory.DirichletCharacter.Basic
import Mathlib.NumberTheory.SmoothNumbers
import EvalTools.Markers

/-!
# Main Statements from Higher uniformity of bounded multiplicative functions in short intervals
# on average

We formalise the statements of the main results from K. Matomäki, M. Radziwiłł, T. Tao,
J. Teräväinen, and T. Ziegler,
`Higher uniformity of bounded multiplicative functions in short intervals on average`,
Annals of Math, 197 (2) 2023.
-/

set_option autoImplicit false

namespace BoundedMultiplicativeFunctions

open Polynomial Finset Real Complex Filter ArithmeticFunction

open scoped ComplexConjugate

/-- We define an extension of an arithmetic function `f` to the integers by setting
`f z = f 0 = 0` for all `z ≤ 0`. -/
noncomputable def _root_.ArithmeticFunction.intExtension {R : Type*} [Zero R]
    (f : ArithmeticFunction R) (z : ℤ) : R := f ⌊z⌋₊

/-- Given `k : ℕ`, `x H : ℝ` we define the weak Gowers uniformity norm of a function `f : ℤ → ℂ`
by the formula:

`‖f‖_{uᵏ⁺¹[x, x + H]} :=`
  `sup_{P ∈ ℝ[X] | degree(P) ≤ k} (1/H) |∑_{x ≤ n ≤ x + H} f(n)exp(2πi(-P(n)))|`. -/
noncomputable
def weakGowersUniformityNorm (k : ℕ) (x H : ℝ) (f : ℤ → ℂ) : ℝ :=
  ⨆ P ∈ degreeLE ℝ k, 1 / H * ‖∑ n ∈ Icc ⌈x⌉ ⌊x + H⌋, f n * cexp (2 * π * I * - P.eval (n : ℝ))‖

/-- We say that a function `f : ℕ → ℂ` is 1-bounded if for all `n : ℕ`, `‖f n‖ ≤ 1`. -/
abbrev IsOneBounded (f : ℕ → ℂ) : Prop := ∀ n, ‖f n‖ ≤ 1

/-- Given `X : ℝ`, we define a distance `𝔻` on functions `ℕ → ℂ` by the formula:

`𝔻(f,g;X) := (∑_{p ≤ X | p is prime} ((1 - Re(f(p) conj(g(p)))) / p)) ^ (1/2)`.
-/
noncomputable
def 𝔻 (f g : ℕ → ℂ) (X : ℝ) : ℝ :=
  (∑ p ∈ ⌊X⌋₊.primesLE, (1 - (f p * conj (g p)).re) / p) ^ (1 / (2 : ℝ))

/-- Given `f : ℕ → ℂ`, `X : ℝ` and `Q : ℕ+`, we define the quantity

`M(f;X,Q) := inf_{|t| ≤ X} inf_{χ ∈ {Dirichlet character mod q s.t q ≤ Q}} 𝔻(f, n ↦ χ(n)n ^ it; X)`.
-/
noncomputable
def M (f : ℕ → ℂ) (X : ℝ) (Q : ℕ+) : ℝ :=
  ⨅ t : {t // |t| ≤ X}, ⨅ q : {q // q ≤ Q}, ⨅ (χ : DirichletCharacter ℂ q),
    𝔻 f (fun n ↦ χ n * n ^ (I * t)) X

/--
Statement of Theorem 1.3 (Non-pretentious multiplicative functions do not correlate
with polynomial phases on short intervals on average):

Let `k : ℕ`, `θ : ℝ` such that `0 < θ < 1/2` and `η : ℝ` such that `η > 0`. Then there exist
constants `Q : ℕ` such that `Q > 0`, `C : ℝ` such that `C > 0`, and `B : ℝ`, such that for any
multiplicative 1-bounded arithmetic function `f : ℕ → ℂ`, any `X : ℝ` such that `X ≥ 1` and any
`H : ℝ` such that `Xᶿ ≤ H ≤ X¹⁻ᶿ`, if

`∫ x ∈ [X, 2X], ‖f‖_{uᵏ⁺¹[x, x + H]}dx ≥ ηX`

then

`M(f;CXᵏ⁺¹/Hᵏ⁺¹,Q) ≤ B`.
-/
@[eval_problem]
theorem theorem_1_3 (k : ℕ) (θ : ℝ) (hθ₀ : 0 < θ) (hθ₁ : θ < 1 / 2) (η : ℝ) (hη : η > 0) :
    ∃ (Q : ℕ+) (_hQ : 1 ≤ Q) (C : ℝ) (_hC : 0 < C) (B : ℝ),
      ∀ (f : ArithmeticFunction ℂ) (_hf : f.IsMultiplicative) (_hf' : IsOneBounded f)
        (X : ℝ) (_hX : X ≥ 1) (H : ℝ) (_hXH : X ^ θ ≤ H) (_hHX : H ≤ X ^ (1 - θ)),
          ∫ x in X..(2 * X), weakGowersUniformityNorm k x H f.intExtension ≥ η * X →
            M f (C * X ^ (k + 1) / H ^ (k + 1)) Q ≤ B := by
  sorry

/--
Statement of Corollary 1.1 (Liouville does not correlate with polynomial phases on
short intervals on average):

Let `λ` denote the liouville function. Fix `k : ℕ` and `θ : ℝ` such that `0 < θ < 1`. Then

`∫ x ∈ [X, 2X], ‖λ‖_{uᵏ⁺¹[x, x + Xᶿ]}dx = o(X)`

as `X → ∞`.
-/
@[eval_problem]
theorem corollary_1_1 (k : ℕ) (θ : ℝ) (hθ₀ : 0 < θ) (hθ₁ : θ < 1) :
    (fun X ↦ ∫ x in X..(2 * X), weakGowersUniformityNorm k x (X ^ θ) (fun n ↦ liouville ⌊n⌋₊))
      =o[atTop] (fun X ↦ X) := by
  sorry

end BoundedMultiplicativeFunctions
