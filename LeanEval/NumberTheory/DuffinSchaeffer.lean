import Mathlib.NumberTheory.WellApproximable
import EvalTools.Markers

namespace LeanEval.NumberTheory.DuffinSchaeffer

/-!
# The Duffin-Schaeffer conjecture

Koukoulopoulos and Maynard proved the Duffin-Schaeffer conjecture, giving
the exact divergence criterion for almost every real number to admit
infinitely many prescribed approximations by reduced fractions.

Mathlib already defines `addWellApproximable UnitAddCircle delta` as the
set of points lying within `delta n` of a point of exact additive order `n`
for infinitely many positive `n`. Points of exact order `n` on the unit
circle are precisely reduced fractions with denominator `n`.
-/

open MeasureTheory

/-- **Koukoulopoulos-Maynard theorem (Duffin-Schaeffer conjecture).** For nonnegative
approximation radii `delta`, the corresponding limsup set of reduced
rational approximations has full measure exactly when
`sum_n phi(n) * delta(n)` diverges. -/
@[eval_problem]
theorem duffin_schaeffer (δ : ℕ → ℝ) (hδ : ∀ n, 0 ≤ δ n) :
    volume (addWellApproximable UnitAddCircle δ) = 1 ↔
      ¬ Summable fun n : ℕ => n.totient * δ n := by
  sorry

end LeanEval.NumberTheory.DuffinSchaeffer
