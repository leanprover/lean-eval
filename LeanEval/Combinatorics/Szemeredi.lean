import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Combinatorics

/-!
# Szemerédi's theorem

§37 of Oliver Knill's *Some Fundamental Theorems in Mathematics* (the
section's first additional statement, generalizing Roth's theorem from
3-APs to `k`-APs). Every subset of `ℕ` of positive upper density contains
arbitrarily long arithmetic progressions.

mathlib has Roth's theorem (`roth_3ap_theorem_nat`, the `k = 3` case) but
**not** the full Szemerédi theorem. As of 2026 it has not been formalized
in any major proof assistant (a well-known open formalization target).
-/

open scoped BigOperators

/-- A set `A ⊆ ℕ` contains **arbitrarily long arithmetic progressions** if
for every length `k` there is an AP `{a + b·j | j < k}` of common
difference `b ≥ 1` entirely contained in `A`. -/
def ContainsArbitraryAPs (A : Set ℕ) : Prop :=
  ∀ k : ℕ, ∃ a b : ℕ, 1 ≤ b ∧ ∀ j : ℕ, j < k → a + b * j ∈ A

/-- The **upper density** of `A ⊆ ℕ`:
`limsup_{n → ∞} |A ∩ {0,…,n}| / (n+1)`. -/
noncomputable def upperDensity (A : Set ℕ) : ℝ :=
  Filter.limsup
    (fun n : ℕ =>
      (∑ k ∈ Finset.range (n + 1), A.indicator (fun _ => (1 : ℝ)) k) / (n + 1))
    Filter.atTop

/-- **Szemerédi's theorem.** Every subset of `ℕ` of positive upper density
contains arbitrarily long arithmetic progressions. -/
@[eval_problem]
theorem szemeredi (A : Set ℕ) (h : 0 < upperDensity A) :
    ContainsArbitraryAPs A := by
  sorry

end Combinatorics
end LeanEval
