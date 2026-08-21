import Mathlib
import EvalTools.Markers

/-!
# Klartag's construction of lattice sphere packings

Boaz Klartag proved in 2025 that in any dimension n there exists an ellipsoid E ⊂ ℝⁿ of
volume cn² centered at the origin that contains no points of ℤⁿ \ {0}, where c > 0 is
a universal constant. Equivalently, there exists a lattice sphere packing in ℝⁿ whose
density is at least cn²2⁻ⁿ, improving over previously known constructions of (not
necessarily lattice) sphere packings that yielded densities of at most cn⋅log(n)⋅2⁻ⁿ.
The proof utilizes a stochastically evolving ellipsoid that accumulates at least cn²
lattice points on its boundary.

## References

* Boaz Klartag. Lattice packing of spheres in high dimensions using a stochastically evolving ellipsoid. https://arxiv.org/abs/2504.05042

* https://gilkalai.wordpress.com/2025/04/09/boaz-klartag-striking-new-lower-bounds-for-sphere-packing-in-high-dimensions/

* https://www.quantamagazine.org/new-sphere-packing-record-stems-from-an-unexpected-source-20250707/
-/

namespace LeanEval.Geometry.KlartagPacking

/-- Klartag's theorem. In the statement, the ellipsoid E is realized as the image of a ball
under a linear map, which we do not require to be of full rank, since if it is not of full
rank, then the volume of E is zero and the conclusion is not satisfied. -/
@[eval_problem]
theorem klartag_packing : ∃ c : ℝ, 0 < c ∧ ∀ n : ℕ,
    let V := EuclideanSpace ℝ (Fin (n + 1))
    ∃ φ : V →ₗ[ℝ] V, let E := φ '' Metric.ball (0 : V) 1
      (MeasureTheory.volume E : EReal) = c * n ^ 2 ∧
      {v ∈ E | ∀ i, v i ∈ Set.range ((↑) : ℤ → ℝ)} = {0} := by
  sorry

end LeanEval.Geometry.KlartagPacking
