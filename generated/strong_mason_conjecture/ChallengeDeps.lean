import Mathlib

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



end LeanEval.Combinatorics.StrongMason
