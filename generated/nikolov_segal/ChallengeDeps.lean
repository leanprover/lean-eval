import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

namespace LeanEval
namespace GroupTheory

/-!
# Nikolov–Segal strong completeness theorem

A profinite group is **strongly complete** when all of its finite-index subgroups are open.
Nikolov and Segal proved that every topologically finitely generated profinite group is strongly
complete. In particular, its topology is determined by its underlying abstract group structure.

## References

* [Nikolov and Segal, *On finitely generated profinite groups, I: strong completeness and uniform
  bounds*](https://doi.org/10.4007/annals.2007.165.171), Theorem 1.1.
* [Nikolov and Segal, *On finitely generated profinite groups, II: products in quasisimple
  groups*](https://doi.org/10.4007/annals.2007.165.239).
-/

/-- A topological group is topologically finitely generated if some finite set generates a dense
abstract subgroup. -/
def IsTopologicallyFinitelyGenerated
    (G : Type*) [Group G] [TopologicalSpace G] [IsTopologicalGroup G] : Prop :=
  ∃ S : Finset G, (Subgroup.closure (S : Set G)).topologicalClosure = ⊤



end GroupTheory
end LeanEval
