import Mathlib
import EvalTools.Markers

namespace LeanEval.Combinatorics.KonigMatching

/-!
# König's theorem (matching = vertex cover)

`konig_matching_vertex_cover`: in a finite bipartite graph, the maximum size of a
matching equals the minimum size of a vertex cover. The trusted helper
`matchingNumber` (the supremum of edge counts over matching subgraphs) is a
non-hole. Mathlib has `SimpleGraph.Subgraph.IsMatching` and a vertex-cover
number, but not König's min-max theorem. Category-(b) candidate from §172 of the
Knill survey.
-/

open SimpleGraph

/-- The matching number of a graph, as the supremum of the number of edges in a
matching subgraph. -/
noncomputable def matchingNumber {V : Type*} (G : SimpleGraph V) : ℕ∞ :=
  ⨆ (M : G.Subgraph) (_ : M.IsMatching), M.edgeSet.encard

/-- **König's theorem.** In a finite bipartite graph, the maximum size of a
matching equals the minimum size of a vertex cover. -/
@[eval_problem]
theorem konig_matching_vertex_cover {V : Type*} [Finite V] (G : SimpleGraph V)
    (hG : G.IsBipartite) :
    matchingNumber G = G.vertexCoverNum := by
  sorry

end LeanEval.Combinatorics.KonigMatching
