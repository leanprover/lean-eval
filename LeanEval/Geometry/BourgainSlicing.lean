import Mathlib
import EvalTools.Markers

/-!
# Affirmative resolution of Bourgain's slicing problem

For any convex body K ⊆ ℝⁿ⁺¹ of volume one, there exists a hyperplane H ⊆ ℝⁿ⁺¹ such that
Volₙ(K ∩ H) > c for some universal constant c > 0.

The second reference below talks about convex sets instead of convex bodies, and
the result probably still holds for convex sets, but the formal statement uses
`ConvexBody` just to be safe.

## References

* Boaz Klartag, Joseph Lehec. Affirmative Resolution of Bourgain's Slicing Problem using Guan's Bound.
  https://arxiv.org/abs/2412.15044, published at https://link.springer.com/article/10.1007/s00039-025-00718-w.
* Qingyang Guan. A note on Bourgain's slicing problem. https://arxiv.org/abs/2412.09075
* https://gilkalai.wordpress.com/2024/12/20/qingyang-guan-joseph-lehec-and-boaz-klartag-solved-the-slice-conjecture/
-/

namespace LeanEval.Geometry.BourgainSlicing

/-- The hyperplane in ℝⁿ⁺¹ is represented as an isometric image of ℝⁿ. Instead of worrying about
normalization of the `n`-dimensional Hausdorff measure on the hyperplane, we use the standard
volume of the preimage of the convex body in ℝⁿ. -/
@[eval_problem]
theorem guan_lehec_klartag : let E (n : ℕ) := EuclideanSpace ℝ (Fin n)
    ∃ c : NNReal, 0 < c ∧
      ∀ (n : ℕ) (K : ConvexBody (E (n + 1))), MeasureTheory.volume (SetLike.coe K) = 1 →
      ∃ f : E n → E (n + 1), Isometry f ∧ c < MeasureTheory.volume (f ⁻¹' K) := by
  sorry

end LeanEval.Geometry.BourgainSlicing
