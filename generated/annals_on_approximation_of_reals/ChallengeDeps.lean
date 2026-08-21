import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.FieldTheory.Minpoly.Basic
import Mathlib.RingTheory.Algebraic.Defs
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from On approximation to a real number by algebraic numbers of bounded degree

We formalise the statement of the main result from A. Poëls,
`On approximation to a real number by algebraic numbers of bounded degree`,
Annals of Math, 201 (1) 2025.
-/

set_option autoImplicit false

namespace OnApproximationOfReals

open NNReal ENNReal

/-- The height of an algebraic number is the maximum of the absolute value of the coefficients
of its minimal polynomial. -/
noncomputable def height (α : ℂ) : ℕ :=
  -- Let `p` be the minimal polynomial of `α`, defined to be monic and over `ℚ`.
  letI p := minpoly ℚ α
  -- Now let `D` be the LCM of the denominators of the nonzero coefficients.
  letI D := Multiset.lcm (Multiset.map (fun i ↦ (p.coeff i).den) p.support.val)
  -- The height of `α` is the supremum of the finite set of `|n|`, where `n` runs
  -- through the numerators of the nonzero coefficients of `D * p`.
  Finset.sup p.support (fun i ↦ (D * p.coeff i).num.natAbs)

/-- The type of complex algebraic numbers whose minimal polynomial has
degree at most `n`. -/
def AlgebraicDegLE (n : ℕ) : Type :=
  {α : ℂ // IsAlgebraic ℚ α ∧ Polynomial.natDegree (minpoly ℚ α) ≤ n}

/-- Set of real numbers `ω > 0` for which the inequalities `0 < |ξ − α| ≤ H(α) ^ (- ω - 1)`
admit infinitely many solutions in algebraic numbers `α` of degree at most `n`.
Note: `ω` here is `ω⋆` in the paper. Note that this contains the interval `(0,1)`
by Dirichlet's box principle.
-/
def ω_stars (n : ℕ) (ξ : ℝ) : Set ℝ≥0 :=
  {ω : ℝ≥0 | 0 < ω ∧
    {α : AlgebraicDegLE n | 0 < ‖ξ - α.1‖ ∧ ‖ξ - α.1‖ ≤ (height α.1) ^ (- (ω : ℝ) - 1)}.Infinite}

/-- The classical exponent `ω⋆_n(ξ)` defined as the supremum of the set `ω_stars` defined above. -/
noncomputable def classicalExponent (n : ℕ) (ξ : ℝ) : ℝ≥0∞ :=
  sSup (((↑) : ℝ≥0 → ℝ≥0∞) '' (ω_stars n ξ))

/-- We use notation `ω⋆` for the classical exponent. -/
notation "ω⋆" => classicalExponent



end OnApproximationOfReals
