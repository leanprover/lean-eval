import Mathlib
import EvalTools.Markers

namespace LeanEval.Combinatorics.StrongMason

/-!
# The strong Mason conjecture

For a finite matroid, let `I k` be the number of independent sets of
cardinality `k`. Mason's strongest conjecture says that the normalized
sequence `I k / (n.choose k)` is log-concave, where `n` is the cardinality
of the ground set. Branden and Huh proved this using Lorentzian polynomials;
Anari, Liu, Oveis Gharan, and Vinzant obtained the result independently.

Mathlib supplies the matroid axioms and their independent-set API. The
inequality below clears the binomial denominators, so it can be stated
entirely in `Nat`.
-/

/-- The number of independent `k`-element subsets of a finite matroid's
ground set. -/
noncomputable def independentSetCount {α : Type*} (M : Matroid α) [M.Finite]
    (k : ℕ) : ℕ :=
  {I ∈ Set.powersetCard α k | M.Indep I}.ncard

/-- **The strong Mason conjecture** (Branden-Huh; independently
Anari-Liu-Oveis Gharan-Vinzant). If `I k` counts the independent sets of
size `k` in a finite matroid on `n` elements, then

`I k ^ 2 * k * (n - k) >= I (k - 1) * I (k + 1) * (k + 1) * (n - k + 1)`.

Equivalently, `I k / n.choose k` is a log-concave sequence. -/
@[eval_problem]
theorem strong_mason_conjecture {α : Type*} (M : Matroid α) [M.Finite]
    (k : ℕ) (hk : 0 < k) (hkn : k < M.E.ncard) :
    independentSetCount M (k - 1) * independentSetCount M (k + 1) *
          (k + 1) * (M.E.ncard - k + 1) ≤
      independentSetCount M k ^ 2 * k * (M.E.ncard - k) := by
  sorry

end LeanEval.Combinatorics.StrongMason
