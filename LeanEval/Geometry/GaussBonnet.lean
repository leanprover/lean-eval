import Mathlib
import EvalTools.Markers

/-!
# The Gauss-Bonnet theorem

There are many versions of the Gauss-Bonnet theorem. Here we propose the problem
to prove the two-dimensional, boundaryless, not-necessarily-oriented version for
metrics which arise from smooth Riemannian metrics.

We do not define the Euler characteristic by purely topological methods and instead
merely require a proof that the integral of the curvature quantises.

-/

namespace LeanEval.Geometry

open scoped ContDiff Manifold MeasureTheory Real Topology

local notation "𝔼²" => EuclideanSpace ℝ (Fin 2)

open Bundle Filter MeasureTheory Metric in
/-- Note that since we don't assume oriented, the Euler characteristic need not be even.

Note also that Mathlib's Hausdorff measure is "unnormalised". To make the statement appear
with familiar constants, we state the theorem using a measure `μ` which is `4 / π` times
the Hausdorff area measure.

Note finally that we do not include assumptions `IsContinuousRiemannianBundle` or
`BoundarylessManifold` since these follow from the other assumptions. -/
@[eval_problem]
theorem gauss_bonnet
    (M : Type*) [MetricSpace M] [ConnectedSpace M] [CompactSpace M]
    [MeasurableSpace M] [BorelSpace M]
    [ChartedSpace 𝔼² M] [IsManifold (𝓡 2) ∞ M]
    [RiemannianBundle (B := M) (TangentSpace (𝓡 2))]
    [IsContMDiffRiemannianBundle (B := M) (𝓡 2) ∞ 𝔼² (TangentSpace (𝓡 2))]
    [IsRiemannianManifold (𝓡 2) M]
    (μ : Measure M)
    (hμ : μ = (NNReal.pi / 4) • μH[2])
    (K : M → ℝ)
    (hK : ∀ x,
      letI A := fun r ↦ (μ (ball x r)).toReal
      letI Q := fun r ↦ 12 * (π * r ^ 2 - A r) / (π * r ^ 4)
      Tendsto Q (𝓝[>] 0) (𝓝 (K x))) :
    ∃ n : ℕ, ∫ x, K x ∂μ = 2 * π * (2 - (n : ℝ)) := by
  sorry

end LeanEval.Geometry
