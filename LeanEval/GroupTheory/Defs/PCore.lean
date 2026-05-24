import Mathlib

namespace LeanEval
namespace GroupTheory
namespace Defs

/-- `pCore p G` is the largest normal `p`-subgroup of `G` — the supremum of
all normal `p`-subgroups. Classically denoted `O_p(G)`.

For a finite group this supremum is itself a `p`-group (any two normal
`p`-subgroups generate a normal `p`-subgroup, and finiteness bounds the chain),
so the definition agrees with the textbook one. For an infinite group the
supremum may fail to be a `p`-group, but the definition still makes sense as
the largest normal subgroup with the closure property required by Baer–Suzuki.
-/
def pCore (p : ℕ) (G : Type*) [Group G] : Subgroup G :=
  sSup {N : Subgroup G | N.Normal ∧ IsPGroup p N}

end Defs
end GroupTheory
end LeanEval
