import TauCeti.LowDimTopology.DehnSurgery.NontrivialKnot
import EvalTools.Markers

open Metric
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

attribute [local instance] TauCeti.finrank_euclideanSpace_fin_succ_fact

/-!
# The Kronheimer–Mrowka Property P Theorem

Peter B. Kronheimer and Tomasz S. Mrowka (2004, *Witten's conjecture and
Property P*, *Geom. Topol.* 8, 295–310; completing the reduction to $\pm 1$
surgeries via the cyclic surgery theorem of Culler–Gordon–Luecke–Shalen 1987,
*Ann. of Math.* 125, 237–300, and combining symplectic fillings, Seiberg–Witten
and Donaldson invariants, taut foliations of Gabai, and $\mathrm{SU}(2)$
representations) resolved Kirby's Problem 1.15: every nontrivial smooth knot in
$S^3$ has Property P — no nontrivial Dehn surgery on it yields a simply
connected $3$-manifold.

The statement is `TauCeti.KronheimerMrowkaPropertyPTheorem` spelled out.
-/

/-- **Kronheimer–Mrowka Property P theorem.** Every smooth knot in $S^3$ that is
not smoothly ambient isotopic to the unknot has Property P (no Dehn filling of
its exterior along a non-meridional slope is simply connected). -/
@[eval_problem]
theorem kronheimer_mrowka_property_p
    (K : TauCeti.SmoothCircleEmbedding (𝓡 3) (sphere (0 : EuclideanSpace ℝ (Fin 4)) 1))
    (hK : ¬ TauCeti.SmoothEmbedding.SmoothAmbientIsotopic K TauCeti.unknot) :
    TauCeti.HasPropertyP K := by
  sorry

end Topology
end LeanEval
