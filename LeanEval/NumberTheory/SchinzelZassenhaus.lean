import Mathlib.NumberTheory.NumberField.House

/-!
# The Schinzel–Zassenhaus Conjecture

This file records a Lean statement of Dimitrov's theorem as it appears in
Chapter 4 of McKee and Smyth, *Around the Unit Circle*.

Let `α₁, ..., αₙ` denote the conjugates of a nonzero algebraic
integer `α` which is not a root of unity.  The Schinzel–Zassenhaus
conjecture asserts that there is an absolute constant `c > 0` such that

`max_{1 ≤ j ≤ n} |αⱼ| > 1 + c / d`.

The quantity `maxⱼ |αⱼ|` is called the house of `α`; in Mathlib this
is `NumberField.house`.

## Reference

The formalization is based on Chapter 4 ("The Schinzel–Zassenhaus Conjecture") of the book:
* **James McKee, Chris Smyth**, *Around the Unit Circle: Mahler Measure, Integer Matrices and Roots of Unity*, Springer, Universitext, 2021.
（https://link.springer.com/chapter/10.1007/978-3-030-80031-4_4）
-/

namespace LeanEval.NumberTheory

/-- **Dimitrov's theorem**, McKee–Smyth Theorem 4.1.

Let `α` be a nonzero algebraic integer, not a root of unity.  Then the
house of `α` is at least `2 ^ (1 / (4 * d'))`, where `d'` is the number of
different phases among its conjugates.

The condition "not a root of unity" is expressed as `¬ IsOfFinOrder α`,
Mathlib's standard predicate for an element having no positive power equal to 1.
-/

theorem dimitrov {K : Type*} [Field K] [NumberField K]
    (α : K)
    (α_int : IsIntegral ℤ α)
    (α_ne_zero : α ≠ 0)
    (α_not_rootOfUnity : ¬ IsOfFinOrder α) :
    (2 : ℝ) ^ (1 / (4 * (Finset.univ.image fun σ : K →+* ℂ ↦ (σ α).arg).card) : ℝ) ≤
      NumberField.house α := by
  sorry

end LeanEval.NumberTheory