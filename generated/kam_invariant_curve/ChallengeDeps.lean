import Mathlib

namespace LeanEval
namespace Dynamics

/-!
# KAM persistence of an invariant curve of a twist map

`kam_invariant_curve` is the Kolmogorov–Arnold–Moser theorem in the
twist-map setting: for Diophantine rotation number `α` and a real-analytic,
`1`-periodic, non-constant, mean-zero `f`, the invariant curve `q₀(t) = t` of
the integrable case `c = 0` persists, for small `|c|`, as a smooth strictly
increasing solution `q` (with `q − id` periodic) of the functional equation
`q(t+α) − 2q(t) + q(t−α) = c·f(q(t))`.

The linearisation at `c = 0` is not invertible (`L̂₀ = 0`), so the implicit
function theorem fails and one faces small divisors `[2cos(2πnα)−2]⁻¹`; the
Diophantine condition makes the Newton/Nash–Moser scheme converge. The trusted
helper `IsDiophantine` (a non-hole) fixes the arithmetic condition. Mathlib has
no KAM theory (no twist maps, invariant curves, small divisors, or Nash–Moser).

This is a category-(b) candidate from §83 of the Knill survey
(`sections/083-kam.md`). (The Poincaré–Siegel linearisation companion is not
included here.)
-/

open scoped ContDiff

/-- A real `α` is **Diophantine** (KAM exponent `2`): there is `C > 0` with
`C / q² ≤ |α − p/q|` for all integers `p, q` with `q ≠ 0`. -/
def IsDiophantine (α : ℝ) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ p q : ℤ, q ≠ 0 →
    C / (q : ℝ) ^ 2 ≤ |α - (p : ℝ) / (q : ℝ)|



end Dynamics
end LeanEval
