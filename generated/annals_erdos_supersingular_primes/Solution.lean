/-
Copyright (c) 2026 Justus Springer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Justus Springer
-/

import Mathlib.Analysis.Complex.Exponential
import Submission
import ChallengeDeps
/-!
# Main Statement from A conjecture of Erdős, supersingular primes and short character sums

We formalise the statement of the main result from M. Bennett and S. Siksek,
`A conjecture of Erdős, supersingular primes and short character sums`,
Annals of Math, 191 (2) 2020.
-/

set_option autoImplicit false

namespace ErdosSupersingularPrimes

open Int Real



/-- The absolute constant such that for all `k ≥ k₀`, the theorem holds.

Part of the theorem statement is that `k₀` should be "effectively computable".
In principle, this means that the definition of `k₀` should avoid `Classical.choice`.
Unfortunately, this is not currently enforceable in Comparator.
Note that prohibiting `noncomputable` is not sufficient:
https://leanprover.zulipchat.com/#narrow/channel/583341-Model-comparisons-for-Lean/topic/LeanEval/near/598595369 -/
@[reducible] noncomputable def k₀ : ℕ := Submission.ErdosSupersingularPrimes.k₀

/--
Statement of Theorem 2:

There is an effectively computable absolute constant `k₀` such
that if `k ≥ k₀` is a positive integer, then any `Solution` with prime exponent `l` satisfies
either `y = 0` or `d = 0` or `l ≤ exp(10 ^ k)`.
-/
theorem theorem_2 (k : ℕ) (hk : k ≥ k₀) (s : Solution k) (hs : s.l.Prime) :
    s.y = 0 ∨ s.d = 0 ∨ s.l ≤ exp (10 ^ k) := Submission.ErdosSupersingularPrimes.theorem_2 k hk s hs

end ErdosSupersingularPrimes
