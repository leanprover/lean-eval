import Mathlib
import EvalTools.Markers

/-!

# Non-smoothable compact four-manifolds

In 1982, Freedman proved that every symmetric unimodular bilinear form over `ℤ` arises as the
intersection form of a closed, oriented, simply-connected topological 4-manifold. In particular
there exists such a manifold with the `E₈` form as intersection form (moreover because `E₈` is
even, this is the unique such manifold with this intersection form). However by Rokhlin's theorem
(or Donaldson's theorem) there is no (closed, oriented, simply-connected) smooth four-manifold with
this intersection form.

We ask here for a proof of the corollary: there exists a closed, simply-connected, topological
four-manifold which cannot be smoothed.

# References:
- Freedman, M., The topology of four-dimensional manifolds, JDG. pp 357--453, 17(3) (1982)

-/

namespace LeanEval.Geometry

open scoped Manifold ContDiff

local notation "𝔼⁴" => EuclideanSpace ℝ (Fin 4)

/-- Freedman's theorem: there exists a closed, simply-connected, topological four-manifold which
cannot be smoothed.

Note the fact that `M` is boundaryless follows from `ModelWithCorners.instBoundarylessManifold`. -/
theorem four_manifold_not_smooth :
    ∃ (M : Type*) (_ : TopologicalSpace M) (_: CompactSpace M) (_ : SimplyConnectedSpace M)
      (_ : Nonempty (ChartedSpace 𝔼⁴ M)),
      ∀ (_ : ChartedSpace 𝔼⁴ M), ¬ IsManifold (𝓡 4) ∞ M := by
  sorry

end LeanEval.Geometry
