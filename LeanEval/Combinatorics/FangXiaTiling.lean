import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Combinatorics
namespace FangXiaTilingProblem

/-!
# Fang–Xia: tiling of the symmetric group by transpositions

If `T_n = {1} ∪ {all transpositions}` and `(T_n, Y)` is a tiling of the
symmetric group `S_n` (every element of `S_n` has a unique factorisation
`x · y` with `x ∈ T_n`, `y ∈ Y`), then every integer partition `λ` of
`n` whose Young-diagram content sum is nonnegative forces `Y` to be
**λ-transitive** in the Martin–Sagan sense: every pair of ordered set
partitions of shape `λ` is connected by exactly a fixed positive number
of permutations in `Y`. Fang–Xia, *Tiling the symmetric group by
transpositions*, Bull. London Math. Soc. **58**(5) (2026); DOI
`10.1112/blms.70366`; arXiv:2506.00360.
-/

open scoped BigOperators

/-- A factorisation/tiling `(X, Y)` of a group: every element has a
unique representation `x * y` with `x ∈ X` and `y ∈ Y`. -/
def IsTiling {G : Type*} [Group G] (X Y : Set G) : Prop :=
  ∀ g : G, ∃! p : X × Y, (p.1 : G) * (p.2 : G) = g

/-- `T_n` — the identity plus all transpositions in `S_n`. -/
def transpositionsWithOne (n : ℕ) : Set (Equiv.Perm (Fin n)) :=
  {σ | σ = 1 ∨ ∃ i j : Fin n, i ≠ j ∧ σ = Equiv.swap i j}

/-- A weakly-decreasing list of positive row lengths summing to `n`:
the concrete encoding of an integer partition of `n`. -/
structure PartitionShape (n : ℕ) where
  parts : List ℕ
  sorted : parts.Pairwise (· ≥ ·)
  positive : ∀ a ∈ parts, 0 < a
  sum_eq : parts.sum = n

namespace PartitionShape

/-- Auxiliary zero-indexed content sum for a list of row lengths. -/
def contentSumAux : ℕ → List ℕ → ℤ
  | _, [] => 0
  | i, a :: as => (a : ℤ) * ((a : ℤ) - 2 * (i : ℤ) - 1) + contentSumAux (i + 1) as

/-- The paper's content-sum condition, written in the equivalent
row-length formula from the remark after Theorem 1.4. Rows are
zero-indexed here, so the `i`-th term is `aᵢ · (aᵢ − 2i − 1)`,
matching the paper's one-indexed `λ_i · (λ_i − 2i + 1)`. -/
def contentSum {n : ℕ} (lam : PartitionShape n) : ℤ :=
  contentSumAux 0 lam.parts

end PartitionShape

/-- An ordered set partition of `Fin n` with block sizes given by
`lam`. -/
structure OrderedSetPartition {n : ℕ} (lam : PartitionShape n) where
  block : Fin lam.parts.length → Finset (Fin n)
  card_block : ∀ i : Fin lam.parts.length, (block i).card = lam.parts.get i
  pairwise_disjoint :
    Pairwise fun i j : Fin lam.parts.length => Disjoint (block i) (block j)
  union_eq_univ : (Finset.univ.biUnion block) = Finset.univ

/-- A permutation sends an ordered set partition `P` to `Q` blockwise. -/
def SendsPartition {n : ℕ} (σ : Equiv.Perm (Fin n)) {lam : PartitionShape n}
    (P Q : OrderedSetPartition lam) : Prop :=
  ∀ i : Fin lam.parts.length, (P.block i).image σ = Q.block i

/-- λ-transitivity in the Martin–Sagan sense: every pair of ordered
set partitions of shape `λ` is connected by exactly a fixed positive
number of elements of `Y`. -/
def IsPartitionTransitive {n : ℕ} (Y : Set (Equiv.Perm (Fin n)))
    (lam : PartitionShape n) : Prop :=
  ∃ r : ℕ, 0 < r ∧
    ∀ P Q : OrderedSetPartition lam,
      {σ : Equiv.Perm (Fin n) | σ ∈ Y ∧ SendsPartition σ P Q}.ncard = r

/-- **Fang–Xia, Theorem 1.4.** A tiling `(T_n, Y)` of `S_n` forces
λ-transitivity of `Y` for every partition `λ` of `n` whose Young-
diagram content sum is nonnegative. -/
@[eval_problem]
theorem fang_xia_partition_transitive_of_tiling
    {n : ℕ} {Y : Set (Equiv.Perm (Fin n))}
    (_h : IsTiling (transpositionsWithOne n) Y) :
    ∀ lam : PartitionShape n, 0 ≤ lam.contentSum → IsPartitionTransitive Y lam := by
  sorry

end FangXiaTilingProblem
end Combinatorics
end LeanEval
