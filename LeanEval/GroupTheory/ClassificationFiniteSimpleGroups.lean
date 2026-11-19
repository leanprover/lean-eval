import TauCeti.GroupTheory.SpecificGroups.CFSG.Classification
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# The classification of finite simple groups

Every finite simple group is isomorphic to one of:

* a cyclic group of prime order;
* an alternating group `Aₙ` with `n ≥ 5`;
* a finite simple group of Lie type, from one of the sixteen families
  `Aₙ(q)`, `²Aₙ(q)`, `Bₙ(q)`, `Cₙ(q)`, `Dₙ(q)`, `²Dₙ(q)`, `E₆(q)`, `²E₆(q)`,
  `E₇(q)`, `E₈(q)`, `F₄(q)`, `G₂(q)`, `³D₄(q)`, `²B₂(2^(2m+1))`,
  `²G₂(3^(2m+1))`, `²F₄(2^(2m+1))`, or the Tits group `²F₄(2)'`;
* one of the twenty-six sporadic groups.

The list, and the groups on it, are those of the Tau Ceti project
(`TauCeti.CFSGIndex` and `TauCeti.CFSGIndex.Group`): the cyclic and alternating
entries are `Multiplicative (ZMod p)` and Mathlib's `alternatingGroup (Fin n)`;
each Lie-type entry is an explicit construction, the derived subgroup of the
fixed points of a Steinberg endomorphism modulo its centre; and each sporadic
entry is the group of an explicit finite presentation. The index carries the
conventional parameter ranges and excludes the small duplicates, following
Gorenstein, Lyons and Solomon and the ATLAS.

The statement is exactly `TauCeti.ClassificationStatement`, spelled out. It asks
only that every finite simple group appear on the list, and does not ask for the
converse (that each listed group is finite and simple) or for the list to be
irredundant.
-/

/-- **The classification of finite simple groups.** -/
@[eval_problem]
theorem classification_finite_simple_groups
    (G : Type) [Group G] [Finite G] [IsSimpleGroup G] :
    ∃ i : TauCeti.CFSGIndex, Nonempty (G ≃* i.Group) := by
  sorry

end GroupTheory
end LeanEval
