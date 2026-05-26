import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# Brauer–Fowler theorem

Let `G` be a finite simple group with an involution `t`. Then `|G|` is
bounded by a function of `|C_G(t)|` alone. Equivalently: for each `n`,
only finitely many finite nonabelian simple groups have an involution
whose centralizer has order `n`.

Stated by Richard Brauer in 1954 (with Fowler) as a key motivation for
the project of classifying finite simple groups: it reduces the
classification (in principle) to studying involution centralizers, a
much smaller class of groups. The first general involution-centralizer
analyses (Brauer–Suzuki, Brauer–Suzuki–Wall, Janko) used this principle
to discover several sporadic simple groups, and it remained one of the
central organising ideas of the CFSG programme.

The bound `f` is not specified — any concrete bound suffices, the
classical Brauer–Fowler bound being roughly `(n^2)!`. The statement
quantifies over all finite simple groups `G` in a fixed universe.

The proof is short and uses only counting / orbit-counting arguments
together with the observation that any two involutions generate a
dihedral subgroup; no deep machinery is required.
-/

/-- **Brauer–Fowler theorem.** There is a function bounding the order
of a finite nonabelian simple group by the order of any involution
centralizer. -/
@[eval_problem]
theorem brauer_fowler :
    ∃ f : ℕ → ℕ, ∀ (G : Type) [Group G] [Finite G],
      IsSimpleGroup G → (∃ a b : G, a * b ≠ b * a) →
      ∀ t : G, orderOf t = 2 →
        Nat.card G ≤ f (Nat.card (Subgroup.centralizer ({t} : Set G))) := by
  sorry

end GroupTheory
end LeanEval
