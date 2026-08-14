import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# Nikolov–Segal strong completeness theorem

A profinite group is **strongly complete** when all of its finite-index subgroups are open.
Nikolov and Segal proved that every topologically finitely generated profinite group is strongly
complete. In particular, its topology is determined by its underlying abstract group structure.

Here a profinite group is represented, as in Mathlib's `ProfiniteGrp`, by a compact, totally
disconnected topological group. Hausdorffness need not be assumed separately: a totally
disconnected topological group is Hausdorff.

The trusted helper `IsTopologicallyFinitelyGenerated` states the topological, rather than
abstract, finite-generation hypothesis. Mathlib has finite-index subgroups, topological closures,
and profinite groups, but not the uniform verbal-width results for finite groups used in the proof.
Those results ultimately rely on CFSG and results about finite quasisimple groups proved in Part II
of the cited work.
-/

/-- A topological group is topologically finitely generated if some finite set generates a dense
abstract subgroup. -/
def IsTopologicallyFinitelyGenerated
    (G : Type*) [Group G] [TopologicalSpace G] [IsTopologicalGroup G] : Prop :=
  ∃ S : Finset G, (Subgroup.closure (S : Set G)).topologicalClosure = ⊤

/-- **Nikolov–Segal strong completeness theorem.** Every finite-index subgroup of a
topologically finitely generated profinite group is open. -/
@[eval_problem]
theorem nikolov_segal
    (G : Type*) [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
    [CompactSpace G] [TotallyDisconnectedSpace G]
    (_hG : IsTopologicallyFinitelyGenerated G)
    (H : Subgroup G) [H.FiniteIndex] :
    IsOpen (H : Set G) := by
  sorry

end GroupTheory
end LeanEval
