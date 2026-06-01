import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Algebra

/-!
# Abel–Ruffini theorem

§57 of Oliver Knill's *Some Fundamental Theorems in Mathematics*, the
Abel–Ruffini theorem in degree-threshold form: for each `n ≥ 1`, every complex
root of every degree-`n` rational polynomial lies in `solvableByRad ℚ ℂ` if and
only if `n ≤ 4`. This packages solvability of all linear, quadratic, cubic, and
quartic equations by radicals together with the failure of such a universal
statement from degree five onward (Ruffini 1799, Abel 1824, Galois 1832).

mathlib has `solvableByRad` and, in `Mathlib/FieldTheory/AbelRuffini.lean`, one
direction at the level of a single polynomial (`isSolvable_gal_of_irreducible`:
a root in `solvableByRad` forces a solvable Galois group), plus the specific
quintic `X⁵ − 4X + 2` in `Archive/Wiedijk100Theorems/AbelRuffini.lean`. It does
not have the converse (solvable Galois group ⇒ roots in `solvableByRad`, i.e.
the explicit low-degree formulas), nor the full degree-boundary `iff` at `n ≤ 4`.

This is the degree-threshold form. It is distinct from the existing
`solvable_by_radicals_converse` problem, which is the per-polynomial
"solvable extension ↔ solvable Galois group" characterization.
-/

open Polynomial

/-- **Abel–Ruffini theorem** (§57). For each positive `n`, every root in `ℂ` of
every nonzero rational polynomial of degree `n` lies in `solvableByRad ℚ ℂ` iff
`n ≤ 4`. The forward direction packages the explicit Cardano/Ferrari radical
formulas; the reverse is the classical insolvability of the general quintic. -/
@[eval_problem]
theorem abel_ruffini (n : ℕ) (_hn : 1 ≤ n) :
    (∀ p : ℚ[X], p.natDegree = n → ∀ x : ℂ, aeval x p = 0 →
        x ∈ solvableByRad ℚ ℂ) ↔ n ≤ 4 := by
  sorry

end Algebra
end LeanEval
