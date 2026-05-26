import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# 3D smooth Poincaré conjecture (Perelman)

A `proof_wanted` in `Mathlib/Geometry/Manifold/PoincareConjecture.lean`. Every
simply connected compact Hausdorff 3-manifold that admits a smooth structure
is **diffeomorphic** to the standard 3-sphere `𝕊³`.

This is the smooth-category strengthening of the topological 3D Poincaré
conjecture, also proved by Perelman in 2002–2003. In dimension 3 the smooth
and topological Poincaré conjectures are equivalent (every topological
3-manifold admits a unique smooth structure, by Moise's theorem), but the
formal Lean statement carries the smooth structure explicitly via
`IsManifold (𝓡 3) ∞ M` and concludes with a diffeomorphism in the manifold
type `M ≃ₘ⟮𝓡 3, 𝓡 3⟯ 𝕊³`.

mathlib has `ChartedSpace`, `IsManifold`, `Diffeomorph`, `SimplyConnectedSpace`,
`CompactSpace`, and the unit sphere as a smooth manifold but no Ricci flow,
no Hamilton–Perelman surgery, and no Moise theorem.
-/

open scoped Manifold ContDiff
open Metric (sphere)

/-- **3D smooth Poincaré conjecture** (Perelman, 2002–2003). Every simply
connected compact Hausdorff smooth 3-manifold is diffeomorphic to the
standard 3-sphere `𝕊³`. -/
@[eval_problem]
theorem poincare_3d_smooth
    {M : Type*} [TopologicalSpace M] [T2Space M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M] [IsManifold (𝓡 3) ∞ M]
    [SimplyConnectedSpace M] [CompactSpace M] :
    Nonempty (M ≃ₘ⟮𝓡 3, 𝓡 3⟯ sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) := by
  sorry

end Topology
end LeanEval
