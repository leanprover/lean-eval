import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# 3D topological Poincaré conjecture (Perelman)

A `proof_wanted` in `Mathlib/Geometry/Manifold/PoincareConjecture.lean`. Every
simply connected compact Hausdorff 3-manifold is homeomorphic to the standard
3-sphere `𝕊³`.

Proved by Grigori Perelman in 2002–2003 via Hamilton's Ricci flow with surgery
(Perelman's three preprints on the arXiv; Fields Medal awarded but declined,
2006; Clay Millennium Prize awarded 2010, also declined). One of the seven
original Millennium Problems.

mathlib has `ChartedSpace`, `SimplyConnectedSpace`, `CompactSpace`, `T2Space`,
`Homeomorph` (`≃ₜ`), and the unit sphere as a smooth manifold but no
Ricci flow, no Hamilton–Perelman surgery, and no Poincaré conjecture itself.
-/

open Metric (sphere)

/-- **3D topological Poincaré conjecture** (Perelman, 2002–2003). Every
simply connected compact Hausdorff 3-manifold is homeomorphic to the
standard 3-sphere `𝕊³`. -/
@[eval_problem]
theorem poincare_3d_topological
    {M : Type*} [TopologicalSpace M] [T2Space M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [SimplyConnectedSpace M] [CompactSpace M] :
    Nonempty (M ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) := by
  sorry

end Topology
end LeanEval
