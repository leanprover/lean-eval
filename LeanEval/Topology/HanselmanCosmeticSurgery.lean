import TauCeti.LowDimTopology.DehnSurgery.Cosmetic
import EvalTools.Markers

open Metric
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

attribute [local instance] TauCeti.finrank_euclideanSpace_fin_succ_fact

/-!
# Hanselman's Cosmetic Surgery Theorem

The cosmetic surgery conjecture (Gordon 1991; Kirby's Problem 1.81(A)) predicts
that two Dehn surgeries along distinct slopes on a nontrivial knot $K$ in $S^3$
never yield orientation-preservingly homeomorphic $3$-manifolds. Using bordered
Heegaard Floer homology interpreted as immersed curves in the punctured torus,
Jonathan Hanselman (2023, *Heegaard Floer homology and cosmetic surgeries in
$S^3$*, *J. Eur. Math. Soc.* 25, 1627–1651, Theorem 2; strengthening Ni–Wu 2015,
*J. Reine Angew. Math.* 706, 1–17) proved that if two distinct slopes $s_1, s_2$
on a nontrivial smooth knot $K \subset S^3$ are purely cosmetic, then their
preferred-framing surgery coefficients are opposite rationals $\{r, -r\}$ with
either $|r| = 2$ or $|r| = 1 / q$ for some positive integer $q$.

The statement is `TauCeti.HanselmanCosmeticSurgeryTheorem` spelled out.
-/

/-- **Hanselman's cosmetic surgery theorem.** If two distinct slopes $s_1, s_2$
on the exterior of a nontrivial smooth knot $K$ in $S^3$ are purely cosmetic
(their Dehn fillings admit an orientation-preserving homeomorphism respecting
the ambient orientation $o$ of $S^3$), then their surgery coefficients in the
preferred framing are $r$ and $-r$ for some rational $r$ with $|r| = 2$ or
$|r| = 1 / q$ ($q \in \mathbb{N}$, $q > 0$). -/
@[eval_problem]
theorem hanselman_cosmetic_surgery
    (o : TauCeti.HomologicalOrientation (sphere (0 : EuclideanSpace ℝ (Fin 4)) 1)
      (EuclideanSpace ℝ (Fin 3)) 3)
    (K : TauCeti.SmoothCircleEmbedding (𝓡 3) (sphere (0 : EuclideanSpace ℝ (Fin 4)) 1))
    (Φ : TauCeti.SolidTorus → sphere (0 : EuclideanSpace ℝ (Fin 4)) 1)
    (h : TauCeti.IsSolidTorusNeighborhood K Φ)
    (s₁ s₂ : TauCeti.Slope h.framedBoundaryTorus.H)
    (hK : ¬ TauCeti.SmoothEmbedding.SmoothAmbientIsotopic K TauCeti.unknot)
    (hc : h.IsPurelyCosmetic o s₁ s₂) (hne : s₁ ≠ s₂) :
    ∃ r : ℚ,
      (h.preferredFramedBoundaryTorus
        (TauCeti.isZero_reducedSingularHomologyFunctor_one_sphere_euclideanSpace_fin_four
          (ModuleCat.of ℤ ℤ))
        (TauCeti.isZero_reducedSingularHomologyFunctor_two_sphere_euclideanSpace_fin_four
          (ModuleCat.of ℤ ℤ))).value s₁ = r ∧
      (h.preferredFramedBoundaryTorus
        (TauCeti.isZero_reducedSingularHomologyFunctor_one_sphere_euclideanSpace_fin_four
          (ModuleCat.of ℤ ℤ))
        (TauCeti.isZero_reducedSingularHomologyFunctor_two_sphere_euclideanSpace_fin_four
          (ModuleCat.of ℤ ℤ))).value s₂ = ((-r : ℚ) : OnePoint ℚ) ∧
      (|r| = 2 ∨ ∃ q : ℕ, 0 < q ∧ |r| = (q : ℚ)⁻¹) := by
  sorry

end Topology
end LeanEval
