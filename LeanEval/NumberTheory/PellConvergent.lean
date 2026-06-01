import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Pell solutions are convergents of `√d`

§84 of Oliver Knill's *Some Fundamental Theorems in Mathematics*. Lagrange's
theorem: if `d` is a positive squarefree integer and `(x, y)` is a positive
solution of Pell's equation `x² − d y² = 1`, then `x / y` occurs as a
convergent `pₙ / qₙ` of the regular continued fraction of `√d`, connecting the
arithmetic of Pell solutions with the continued-fraction expansion of a
quadratic irrational.

mathlib has the Pell solution group (`Pell.Solution₁`, `Pell.IsFundamental`)
and the continued-fraction algorithm `GenContFract.of` with its convergent
stream `GenContFract.convs`, but no link between the two: there is no
quadratic-irrational / eventually-periodic continued-fraction theory of `√d`,
and nothing relating Pell solutions to convergents.

Since `x² − d y² = 1` forces `gcd x y = 1`, and `convs n` is `pₙ / qₙ` in
lowest terms, `convs n = x / y` is the faithful reading of "`(x, y)` is of the
form `(pₙ, qₙ)`". For `d = 1` the hypotheses `0 < x`, `0 < y`, `x² − y² = 1`
are unsatisfiable; the content lives at squarefree `d ≥ 2`, where `√d` is
irrational and the continued fraction is infinite.
-/

open scoped Real

/-- **Pell solutions are convergents of `√d`** (§84). Let `d` be a positive
squarefree integer and let `(x, y)` be a positive solution of Pell's equation
`x² − d y² = 1`. Then the ratio `x / y` is one of the convergents of the
regular continued fraction of `√d`: there is an index `n` with
`(GenContFract.of √d).convs n = x / y`. -/
@[eval_problem]
theorem pell_solution_is_convergent
    (d : ℤ) (_hd : Squarefree d) (_hd0 : 0 < d)
    (x y : ℤ) (_hx : 0 < x) (_hy : 0 < y)
    (_hsol : x ^ 2 - d * y ^ 2 = 1) :
    ∃ n : ℕ, (GenContFract.of (Real.sqrt (d : ℝ))).convs n = (x : ℝ) / (y : ℝ) := by
  sorry

end NumberTheory
end LeanEval
