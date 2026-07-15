import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Milnor's exotic 7-sphere

A `proof_wanted` in `Mathlib/Geometry/Manifold/PoincareConjecture.lean`. The
existence of a smooth 7-manifold `M` that is homeomorphic to the standard
7-sphere `𝕊⁷` but **not** diffeomorphic to it.

This is John Milnor's 1956 discovery (Milnor, *On manifolds homeomorphic to
the 7-sphere*, Ann. of Math. 64) — the birth of differential topology as a
distinct subject from topology. Milnor exhibited his exotic 7-spheres as
`S³`-bundles over `S⁴` with non-standard smooth structure; their
non-diffeomorphism to `𝕊⁷` is detected by an invariant (Milnor's λ) built
from the signature of an 8-manifold bounding the candidate via Hirzebruch's
signature theorem and an integrality argument that distinguishes the
smooth structures.

mathlib has `ChartedSpace`, `IsManifold`, `Diffeomorph`, `Homeomorph`, and
the unit sphere as a smooth manifold (`Geometry/Manifold/Instances/Sphere.lean`),
but no exotic sphere construction. The statement here is the existential
form recorded as `proof_wanted exists_homeomorph_isEmpty_diffeomorph_sphere_seven`
in mathlib (the eval-problem flavour is the same — produce a smooth
structure on some `M ≃ₜ 𝕊⁷` for which no diffeomorphism `M ≃ₘ⟮𝓡 7, 𝓡 7⟯ 𝕊⁷`
exists).
-/

open scoped Manifold ContDiff
open Metric (sphere)

/-- **Milnor's exotic 7-sphere.** There exists a smooth 7-manifold
homeomorphic to the standard 7-sphere `𝕊⁷` but not diffeomorphic to it. -/
@[eval_problem]
theorem milnor_exotic_sphere_seven :
    ∃ (M : Type) (_ : TopologicalSpace M)
      (_ : ChartedSpace (EuclideanSpace ℝ (Fin 7)) M)
      (_ : IsManifold (𝓡 7) ∞ M)
      (_homeo : M ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin 8)) 1),
      IsEmpty (M ≃ₘ⟮𝓡 7, 𝓡 7⟯ sphere (0 : EuclideanSpace ℝ (Fin 8)) 1) := by
  sorry

end Topology
end LeanEval
