import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.NumberTheory.Harmonic.Defs
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Lake.Toml
import Lake.Util.Message
import Lean

namespace LeanEval
namespace NumberTheory

open scoped ArithmeticFunction.sigma

/-!
Lagarias' elementary criterion for the Riemann hypothesis.

Mathlib already provides `RiemannHypothesis`, harmonic numbers `harmonic`, and the divisor-sum
function `σ`, so the equivalence can be stated directly.
-/

def LagariasElementaryCriterion : Prop :=
  ∀ n : ℕ,
    0 < n →
      ((σ 1 n : ℕ) : ℝ) ≤
        (harmonic n : ℝ) +
          Real.exp (harmonic n : ℝ) * Real.log (harmonic n : ℝ)



end NumberTheory
end LeanEval
