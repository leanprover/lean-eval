import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Analysis.CStarAlgebra.Classes
import Mathlib.FieldTheory.Minpoly.Basic
import Mathlib.RingTheory.Algebraic.Defs
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Algebraic integers with conjugates in a prescribed distribution

We formalise the statement of the main result from A. Smith,
`Algebraic integers with conjugates in a prescribed distribution`, Annals of Math, 200 (1) 2024.
-/

set_option autoImplicit false

namespace AlgebraicIntegers

open ComplexOrder

/-- The trace of an algebraic integer `α ∈ ℂ` is the sum `α₁ + ... + αₙ`, where
`αᵢ` are the complex roots of the minimal polynomial of `α` over `ℚ`. -/
noncomputable def trace (α : ℂ) : ℂ := ((minpoly ℚ α).aroots ℂ).sum

/-- The degree of an algebraic integer is the degree of the minimal polynomial
of `α` over `ℚ`. -/
noncomputable def degree (α : ℂ) : ℕ := (minpoly ℚ α).natDegree

/-- We call an algebraic number `α` totally positive if its conjugates `α₁, ..., αₙ` are all
positive real numbers.

Note that `open ComplexOrder` gives the complex numbers a partial ordering, with `x < y` defined to
mean that `y - x` is a positive real number. -/
def IsTotallyPositive (α : ℂ) : Prop :=
  IsAlgebraic ℚ α ∧ ∀ β ∈ (minpoly ℚ α).aroots ℂ, 0 < β

/-- Take `λ_SSS` to be the greatest real number `λ` such that, for any `ε > 0`,
there are only finitely many totally positive algebraic integers α satisfying
`tr(α) < (λ − ε) * deg(α)`. Note that the paper said "least real number",
but this is clearly a typo, as this set does not have a lower bound. Defining
it as the greatest real number is consistent with how this constant is defined in
another paper by the same author, namely in Orloski, Sardari and Smith: "New
lower bounds for the Schur-Siegel-Smyth trace problem" (arXiv:2401.03252).
There, `λ_SSS` is defined as the limit inferior of `tr(α)/deg(α)` over all
totally positive `α`, which is exactly the *greatest* real number `λ` such that
for all `ε > 0`, only finitely many `α` have `tr(α)/deg(α) < λ - ε`. -/
noncomputable def lambda_SSS : ℝ := sSup { lam : ℝ | ∀ ε > (0 : ℝ),
  { α : ℂ | IsIntegral ℤ α ∧ IsTotallyPositive α ∧ trace α < (lam - ε) * degree α }.Finite }



end AlgebraicIntegers
