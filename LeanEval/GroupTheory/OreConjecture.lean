import Mathlib.Data.Finite.Defs
import Mathlib.GroupTheory.Commutator.Basic
import Mathlib.GroupTheory.Subgroup.Simple
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# The Ore conjecture

Every element of a finite nonabelian simple group is a commutator; Liebeck, O'Brien,
Shalev, and Tiep proved this conjecture in 2010.

## References

* [M. W. Liebeck, E. A. O'Brien, A. Shalev, and P. H. Tiep, *The Ore conjecture*](https://ems.press/journals/jems/articles/3979)
-/

/-- **The Ore conjecture.** Every element of a finite nonabelian simple group is a
commutator. -/
@[eval_problem]
theorem ore_conjecture
    (G : Type*) [Group G] [Finite G] [IsSimpleGroup G]
    (hG : ¬ IsMulCommutative G) :
    commutatorSet G = Set.univ := by
  sorry

end GroupTheory
end LeanEval
