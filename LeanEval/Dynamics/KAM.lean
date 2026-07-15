import Mathlib
import EvalTools.Markers

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

/-- **KAM theorem (persistence of an invariant curve).** For real-analytic,
`1`-periodic, non-constant, mean-zero `f` and Diophantine `α`, for all small
`|c|` the twist-map functional equation
`q(t+α) − 2q(t) + q(t−α) = c·f(q(t))` has a smooth strictly increasing solution
`q` with `q − id` periodic — the `c = 0` curve `q₀(t) = t` persists as a smooth
invariant curve of rotation number `α`. -/
@[eval_problem]
theorem kam_invariant_curve
    (α : ℝ) (_hα : IsDiophantine α)
    (f : ℝ → ℝ)
    (_hf_analytic : AnalyticOnNhd ℝ f Set.univ)
    (_hf_per : Function.Periodic f 1)
    (_hf_nonconst : ¬ ∃ k : ℝ, ∀ x, f x = k)
    (_hf_mean : ∫ x in (0 : ℝ)..1, f x = 0) :
    ∃ c₀ : ℝ, 0 < c₀ ∧ ∀ c : ℝ, |c| < c₀ →
      ∃ q : ℝ → ℝ,
        ContDiff ℝ ∞ q ∧ StrictMono q ∧
        Function.Periodic (fun t => q t - t) 1 ∧
        ∀ t : ℝ, q (t + α) - 2 * q t + q (t - α) = c * f (q t) := by
  sorry

end Dynamics
end LeanEval
