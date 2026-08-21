import Mathlib.Topology.MetricSpace.HausdorffDimension
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statements from On the Duffin-Schaeffer conjecture

We formalise the statements of the main results from D. Koukoulopoulos and J. Maynard,
`On the Duffin-Schaeffer conjecture`, Annals of Math, 192 (1) 2020.

## Implementation Details

In the paper, `ℕ` denotes the positive integers, which are denoted `ℕ+` in Lean.
Hence, no changes to the domains of the functions `ψ` and `ψ⋆` have been made in the formalisation.
-/

set_option autoImplicit false

namespace DuffinSchaefferConjecture

open NNReal ENNReal MeasureTheory

open scoped Nat

/-- Inequality 1.7: `|α - a / q| ≤ ψ q / q`. Here `α ∈ ℝ` and `ψ : ℕ → ℝ≥0` is a function. -/
def inequality_1_7 (ψ : ℕ+ → ℝ≥0) (α : ℝ) (a : ℕ) (q : ℕ+) : Prop :=
  |α - a / q| ≤ ψ q / q

/-- Definition of the set `𝒜` appearing in Theorem 1. -/
def 𝒜 (ψ : ℕ+ → ℝ≥0) : Set ℝ :=
  {α ∈ Set.Icc 0 1 | {(a, q) : ℕ × ℕ+ | Nat.Coprime a q ∧ inequality_1_7 ψ α a q}.Infinite}



/-- The set `𝒦` as defined in Theorem 2:
The `α ∈ [0,1]` such that inequality 1.7 `|α - a/q| ≤ ψ(q)/q` has infinitely many solutions `(a, q)`
with `0 ≤ a ≤ q`.

Note: we allow non-coprime `(a, q)` and we explicitly rule out `q = 0`. -/
def 𝒦 (ψ : ℕ+ → ℝ≥0) : Set ℝ :=
  {α ∈ Set.Icc 0 1 | {(a, q) : ℕ × ℕ+ | a ≤ q ∧ inequality_1_7 ψ α a q}.Infinite}

/-- Define `ψ⋆ : ℕ → ℝ≥0∞` by `ψ⋆ : q ↦ φ(q) * sup {ψ(n)/n : n ∈ ℕ+, q|n}`, where `φ` denotes
Euler's totient function. -/
noncomputable def ψ_star (ψ : ℕ+ → ℝ≥0) : ℕ+ → ℝ≥0∞ :=
  fun q ↦ φ q * sSup {r : ℝ≥0∞ | ∃ n : ℕ+, q ∣ n ∧ r = ψ n / n}





/-- The element `s` in the statement of Corollary 3. -/
noncomputable def s_inf (ψ : ℕ+ → ℝ≥0) : ℝ≥0 :=
  sInf {β | Summable fun q : ℕ+ ↦ φ q * (ψ q / q) ^ β.1}



end DuffinSchaefferConjecture
