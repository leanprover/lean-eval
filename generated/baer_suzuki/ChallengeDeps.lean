import Mathlib

namespace LeanEval
namespace GroupTheory
namespace Defs

/-- `pCore p G` is the largest normal `p`-subgroup of `G` — the supremum of
all normal `p`-subgroups. Classically denoted `O_p(G)`.

This is itself a normal `p`-subgroup of `G`, with no finiteness hypothesis
needed: the family of normal `p`-subgroups is *directed* under `≤` (the
join of two normal `p`-subgroups is again a normal `p`-subgroup, using
`Subgroup.sup_normal` and `IsPGroup.to_sup_of_normal_left`), so by
`Subgroup.mem_iSup_of_directed` every element of the supremum already lies
in one of the summands, and therefore has `p`-power order.
-/
def pCore (p : ℕ) (G : Type*) [Group G] : Subgroup G :=
  sSup {N : Subgroup G | N.Normal ∧ IsPGroup p N}

end Defs
end GroupTheory
end LeanEval
