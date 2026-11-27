import TauCeti.Geometry.Manifold.Riemannian.Scaling
import TauCeti.Geometry.Manifold.VectorBundle.CovariantDerivative.Curvature.Scalar
import TauCeti.Geometry.Manifold.VectorBundle.Riemannian.Basic
import EvalTools.Markers

open scoped ContDiff Manifold

namespace LeanEval
namespace Geometry

/-!
# The Yamabe Problem

Hidehiko Yamabe (1960, *Osaka Math. J.* 12, 21–37) proposed proving that every
smooth Riemannian metric $g$ on a closed connected smooth manifold $M$ of
dimension $n \ge 3$ is conformally equivalent to a smooth Riemannian metric of
constant scalar curvature. Following Neil Trudinger's correction and proof for
nonpositive and small positive Yamabe invariant (1968, *Ann. Scuola Norm. Sup.
Pisa* 22, 265–274) and Thierry Aubin's resolution for $n \ge 6$ and non-locally
conformally flat manifolds (1976, *J. Math. Pures Appl.* 55, 269–296), Richard
Schoen completed the proof in the remaining dimensions $n \in \{3, 4, 5\}$ and
locally conformally flat case using the positive mass theorem (1984, *J.
Differential Geom.* 20, 479–495; see also Lee–Parker 1987, *Bull. Amer. Math.
Soc.* 17, 37–91).

Stated against Tau Ceti's `ContMDiffRiemannianMetric`, conformal rescaling
`ContMDiffRiemannianMetric.rescale`, and `scalarCurvature`.
-/

/-- **Resolution of the Yamabe problem (Yamabe; Trudinger; Aubin; Schoen
1984).** On every compact connected Hausdorff boundaryless smooth manifold $M$
of dimension at least $3$, every smooth Riemannian metric $g$ admits a smooth
strictly positive conformal factor $f : M \to \mathbb{R}$ such that the rescaled
metric $f \cdot g$ has constant scalar curvature. -/
@[eval_problem]
theorem yamabe_problem
    {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    {H : Type} [TopologicalSpace H] {I : ModelWithCorners ℝ E H} [I.Boundaryless]
    {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M] [ConnectedSpace M]
    [ChartedSpace H M] [IsManifold I ∞ M]
    (hdim : 3 ≤ Module.finrank ℝ E)
    (g : Bundle.ContMDiffRiemannianMetric I ∞ E (fun x : M ↦ TangentSpace I x)) :
    ∃ (f : M → ℝ) (hf : ContMDiff I 𝓘(ℝ) ∞ f) (hf_pos : ∀ x, 0 < f x) (c : ℝ),
      ∀ x : M, (g.rescale f hf hf_pos).scalarCurvature x = c := by
  sorry

end Geometry
end LeanEval
