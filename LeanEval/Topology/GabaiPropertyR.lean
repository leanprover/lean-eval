import TauCeti.LowDimTopology.DehnSurgery.NontrivialKnot
import EvalTools.Markers

open Metric
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

attribute [local instance] TauCeti.finrank_euclideanSpace_fin_succ_fact

/-!
# Gabai's Property R Theorem

David Gabai (1987, *Foliations and the topology of $3$-manifolds. III*, *J.
Differential Geom.* 26, 479–536, Corollary 8.3) resolved Kirby's Problem 1.82
for knots using sutured manifold hierarchies and taut foliations: every
nontrivial smooth knot $K$ in $S^3$ has Property R, meaning longitudinal
$0$-surgery on $K$ is never homeomorphic to $S^1 \times S^2$.

The statement is `TauCeti.GabaiPropertyRTheorem` spelled out.
-/

/-- **Gabai's Property R theorem.** Every smooth knot in $S^3$ that is not
smoothly ambient isotopic to the unknot has Property R (no longitudinal
$0$-surgery on it is homeomorphic to $S^1 \times S^2$). -/
@[eval_problem]
theorem gabai_property_r
    (K : TauCeti.SmoothCircleEmbedding (𝓡 3) (sphere (0 : EuclideanSpace ℝ (Fin 4)) 1))
    (hK : ¬ TauCeti.SmoothEmbedding.SmoothAmbientIsotopic K TauCeti.unknot) :
    TauCeti.HasPropertyR
      (TauCeti.isZero_reducedSingularHomologyFunctor_one_sphere_euclideanSpace_fin_four
        (ModuleCat.of ℤ ℤ))
      (TauCeti.isZero_reducedSingularHomologyFunctor_two_sphere_euclideanSpace_fin_four
        (ModuleCat.of ℤ ℤ))
      K := by
  sorry

end Topology
end LeanEval
