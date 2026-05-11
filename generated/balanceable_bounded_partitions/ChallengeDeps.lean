import Mathlib

namespace LeanEval
namespace Combinatorics

/--
A partition is `k`-bounded if all of its members are at most `k`.

For example, `12 = 3 + 2 + 2 + 2 + 2 + 1` is a `3`-bounded partition
of `12`.
-/
def Bounded {n : ℕ} (k : ℕ) (p : n.Partition) : Prop :=
  ∀ i ∈ p.parts, i ≤ k

/--
A partition is balanceable if it can be decomposed into two multisets of
the same size.

For example, `12 = (3 + 2 + 1) + (2 + 2 + 2)` is a balanceable partition
of `12`.
-/
def Balanceable {n : ℕ} (p : n.Partition) : Prop :=
  ∃ s₁ s₂, s₁ + s₂ = p.parts ∧ s₁.sum = s₂.sum



end Combinatorics
end LeanEval
