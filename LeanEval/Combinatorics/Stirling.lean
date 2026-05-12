import EvalTools.Markers
import Mathlib.GroupTheory.Perm.Cycle.Factors
import Mathlib.Combinatorics.Enumerative.Stirling
import Mathlib.Order.Partition.Finpartition

/-! # Combinatorial interpretation of the Stirling numbers

Prove that the Stirling numbers, defined in Mathlib by recursion, indeed count their associated
combinatorial objects.

D. Knuth, *The Art of Computer Programming*, Volume 1, §1.2.6.
-/

namespace Nat

open Equiv Finset

/-- `n.stirlingFirst k` counts the number of partitions of a set with cardinality `n` into `k`
disjoint subsets. -/
@[eval_problem]
theorem stirlingFirst_eq_card (n k : ℕ) :
  n.stirlingFirst k =
  Fintype.card {x : Finpartition (α := Finset (Fin n)) .univ // x.parts.card = k} := sorry

/-- `n.stirlingSecond k` sounds the number of permutations of a set with cardinality `n` having `k`
cycles (including those with one-element). -/
@[eval_problem]
theorem stirlingSecond_eq_card (n k : ℕ) :
  n.stirlingSecond k =
  Fintype.card {f : Perm (Fin n) // #f.cycleFactorsFinset + #{x | f x = x} = k} := sorry

end Nat
