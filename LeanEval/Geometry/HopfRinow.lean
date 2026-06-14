import Mathlib
import EvalTools.Markers

open scoped Manifold ENNReal ContDiff

namespace LeanEval
namespace Geometry

/-!
# Hopf–Rinow theorem

For a connected, locally compact, finite-dimensional smooth Riemannian
manifold `M`, metric completeness and geodesic completeness are
equivalent.

The problem ships two helper definitions: `IsGeodesic` (a path with
locally linear `edist` — a metric formulation of affinely parametrised
local minimising geodesics, avoiding any Levi-Civita / connection
infrastructure) and `IsGeodesicallyComplete` (every geodesic on a
bounded open interval extends to all of `ℝ`, the metric analogue of
"the exponential map extends to the whole tangent bundle").

Finite dimensionality is essential: Hopf–Rinow fails on infinite-
dimensional Riemannian Hilbert manifolds. The `IsRiemannianManifold I M`
hypothesis ties `edist` to `riemannianEDist`; full smoothness of the
metric is needed for the proof to construct minimising geodesics via
Picard–Lindelöf on the geodesic ODE.

The `[I.Boundaryless]` hypothesis is also essential: on a manifold *with*
boundary the equivalence fails. The closed interval `[0, 1]` (modelled on
`𝓡∂ 1`) is metrically complete but not geodesically complete — a geodesic
running toward an endpoint cannot extend to all of `ℝ` — so the backward
direction `CompleteSpace M → IsGeodesicallyComplete M` breaks without it.

This statement was corrected on 2026-06-14: the original omitted
`[I.Boundaryless]`, and Lorenzo Luccioli, using Harmonic's Aristotle,
gave a formal disproof via the `[0, 1]` counterexample. Thanks to both.
-/

/-- A path `γ : ℝ → M` is a **(constant-speed) geodesic** if there is
some speed `c : ℝ≥0` such that at every parameter `t₀ : ℝ`, the
Riemannian distance is locally linear in the parameter. -/
def IsGeodesic {M : Type*} [EMetricSpace M] (γ : ℝ → M) : Prop :=
  ∃ c : NNReal, ∀ t₀ : ℝ, ∃ δ > (0 : ℝ),
    ∀ s t : ℝ, |s - t₀| < δ → |t - t₀| < δ →
      edist (γ s) (γ t) = (c : ℝ≥0∞) * ENNReal.ofReal |t - s|

/-- The Riemannian manifold `M` is **geodesically complete** if every
geodesic defined on a bounded open interval `(a, b) ⊂ ℝ` extends to a
geodesic defined on all of `ℝ`. -/
def IsGeodesicallyComplete (M : Type*) [EMetricSpace M] : Prop :=
  ∀ (a b : ℝ) (γ : ℝ → M), a < b →
    (∃ c : NNReal, ∀ t₀ ∈ Set.Ioo a b, ∃ δ > (0 : ℝ),
      ∀ s t : ℝ,
        s ∈ Set.Ioo (max a (t₀ - δ)) (min b (t₀ + δ)) →
        t ∈ Set.Ioo (max a (t₀ - δ)) (min b (t₀ + δ)) →
        edist (γ s) (γ t) = (c : ℝ≥0∞) * ENNReal.ofReal |t - s|) →
    ∃ γext : ℝ → M, IsGeodesic γext ∧ ∀ t ∈ Set.Ioo a b, γext t = γ t

/-- **Hopf–Rinow theorem.** For a connected, locally compact,
finite-dimensional smooth Riemannian manifold `M` *without boundary*,
metric completeness and geodesic completeness are equivalent. -/
@[eval_problem]
theorem hopf_rinow
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    {H : Type*} [TopologicalSpace H] (I : ModelWithCorners ℝ E H)
    [I.Boundaryless]
    (M : Type*) [EMetricSpace M] [ChartedSpace H M] [IsManifold I ∞ M]
    [Bundle.RiemannianBundle (fun x : M => TangentSpace I x)]
    [IsRiemannianManifold I M]
    [LocallyCompactSpace M] [ConnectedSpace M] :
    IsGeodesicallyComplete M ↔ CompleteSpace M := by
  sorry

end Geometry
end LeanEval
