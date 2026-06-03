import Mathlib.NumberTheory.NumberField.Discriminant.Defs
import Mathlib.NumberTheory.NumberField.InfinitePlace.TotallyRealComplex
import EvalTools.Markers

/-!
# Martinet's totally real class-field towers

Jacques Martinet's construction of a totally real number field with an infinite unramified
2-class-field tower gives an infinite family of totally real number fields of unbounded degree and
bounded root discriminant. This is the classical input used as the explicit hypothesis in the
formalization of the real sum-product counterexample.

Assuming Martinet's Proposition 4.1 and Example 4.2: there is a totally real degree-four field
`k'` with an infinite unramified 2-class-field tower and root discriminant
`ρ = 4 * sqrt (3 * 5 * 7 * 23 * 29) < 1059`. Finite layers `K / k'` in the tower have unbounded
degrees, remain totally real, and are unramified at finite primes, so
`|discr K| = |discr k'| ^ [K : k'] = ρ ^ [K : ℚ]`. Hence `C = ρ` works.

Reference: Jacques Martinet, *Tours de corps de classes et estimations de discriminants*,
Inventiones Mathematicae 44 (1978), 65--73, especially §4, Proposition 4.1 and Example 4.2.
-/

namespace LeanEval.NumberTheory

/-- Martinet's bounded-root-discriminant theorem for totally real fields.

There is an absolute constant `C > 0` such that for arbitrarily large degrees `d` there exists a
totally real number field `K / ℚ` of degree `d` whose discriminant satisfies `|Δ_K| ≤ C ^ d`.
-/
def MartinetTotallyRealTowers : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ N : ℕ, ∃ d : ℕ, N ≤ d ∧
    ∃ (K : Type) (_ : Field K) (_ : NumberField K) (_ : NumberField.IsTotallyReal K),
      Module.finrank ℚ K = d ∧ |(NumberField.discr K : ℝ)| ≤ C ^ d

@[eval_problem]
theorem martinet_totally_real_towers : MartinetTotallyRealTowers := by
  sorry

end LeanEval.NumberTheory
