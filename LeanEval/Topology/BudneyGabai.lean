import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

open scoped ContDiff Manifold
open Metric (sphere)

/-!
# Budney--Gabai knotted three-spheres

Corollary 8.6 of Budney and Gabai's *Knotted 3-balls in S^4* states that
`S^1 × S^3` contains infinitely many isotopy classes of embedded three-spheres
homotopic to the standard cross-section `{x₀} × S^3`.

Here `S^1` and `S^3` are the unit spheres in Euclidean two- and four-space.
An isotopy of unparameterized embedded spheres is expressed as a jointly smooth
one-parameter family of smooth embeddings, with equality of ranges at its
endpoints. By the smooth isotopy extension theorem, this agrees with ambient
smooth isotopy. The connected-complement condition records that every sphere is
nonseparating.
-/

/-- **Budney--Gabai, Corollary 8.6.** There are infinitely many pairwise smoothly
non-isotopic, nonseparating embedded three-spheres in `S^1 × S^3`, all homotopic
to the standard cross-section `{x₀} × S^3`. -/
@[eval_problem]
theorem budney_gabai_knotted_three_spheres
    (x₀ : sphere (0 : EuclideanSpace ℝ (Fin 2)) 1) :
    ∃ e : ℕ → sphere (0 : EuclideanSpace ℝ (Fin 4)) 1 →
        sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 ×
          sphere (0 : EuclideanSpace ℝ (Fin 4)) 1,
      (∀ n,
        Manifold.IsSmoothEmbedding
            (𝓡 3) ((𝓡 1).prod (𝓡 3)) ∞ (e n) ∧
          IsConnected (Set.range (e n))ᶜ ∧
          ∃ K : unitInterval × sphere (0 : EuclideanSpace ℝ (Fin 4)) 1 →
              sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 ×
                sphere (0 : EuclideanSpace ℝ (Fin 4)) 1,
            Continuous K ∧
              (∀ p, K (0, p) = e n p) ∧
              ∀ p, K (1, p) = (x₀, p)) ∧
        ∀ i j, i ≠ j →
          ¬ ∃ H : unitInterval × sphere (0 : EuclideanSpace ℝ (Fin 4)) 1 →
              sphere (0 : EuclideanSpace ℝ (Fin 2)) 1 ×
                sphere (0 : EuclideanSpace ℝ (Fin 4)) 1,
            ContMDiff
                ((𝓡∂ 1).prod (𝓡 3)) ((𝓡 1).prod (𝓡 3)) ∞ H ∧
              (∀ t,
                Manifold.IsSmoothEmbedding
                  (𝓡 3) ((𝓡 1).prod (𝓡 3)) ∞ (fun p ↦ H (t, p))) ∧
              Set.range (fun p ↦ H (0, p)) = Set.range (e i) ∧
              Set.range (fun p ↦ H (1, p)) = Set.range (e j) := by
  sorry

end Topology
end LeanEval
