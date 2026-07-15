import Mathlib
import EvalTools.Markers

namespace LeanEval.RepresentationTheory.CompactGroupSemisimple

/-!
# Complete reducibility for compact groups

`compact_group_semisimple`: a continuous representation of a compact topological
group on a finite-dimensional real vector space is semisimple (every
subrepresentation has a `G`-invariant complement). This is the unitarian trick:
averaging an inner product over Haar measure produces a `G`-invariant inner
product. Mathlib has `IsSemisimpleRepresentation` and Maschke's theorem (finite
groups) but no compact-group / Peter–Weyl result. Category-(b) candidate from
§21 of the Knill survey.
-/

open Representation

/-- **Representations of compact groups are semisimple** (complete
reducibility / the unitarian trick). A continuous representation of a compact
topological group on a finite-dimensional real vector space is semisimple:
every subrepresentation has a `G`-invariant complement, so the representation
decomposes as a direct sum of irreducible finite-dimensional
subrepresentations. -/
@[eval_problem]
theorem compact_group_semisimple
    {G V : Type*} [Group G] [TopologicalSpace G] [IsTopologicalGroup G] [CompactSpace G]
    [NormedAddCommGroup V] [NormedSpace ℝ V] [FiniteDimensional ℝ V]
    (ρ : Representation ℝ G V)
    (hρ : Continuous fun p : G × V => ρ p.1 p.2) :
    ρ.IsSemisimpleRepresentation := by
  sorry

end LeanEval.RepresentationTheory.CompactGroupSemisimple
