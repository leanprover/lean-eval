import TauCeti.KnotTheory.SeifertSurface.Basic
import EvalTools.Markers

open Metric Set
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

attribute [local instance] TauCeti.finrank_euclideanSpace_fin_succ_fact

/-!
# The Gordon–Luecke Knot Complement Theorem

Cameron McA. Gordon and John Luecke (1989, *Knots are determined by their
complements*, *J. Amer. Math. Soc.* 2, 371–415, Theorem 1) proved that if two
smooth (or tame) knots $K_1, K_2$ in $S^3$ have homeomorphic complements
$S^3 \setminus K_1 \cong S^3 \setminus K_2$, then there exists a (possibly
orientation-reversing) self-diffeomorphism of $S^3$ carrying $K_1$ onto $K_2$
(equivalently, nontrivial Dehn surgery on a nontrivial knot in $S^3$ never
yields $S^3$).
-/

/-- **Gordon–Luecke knot complement theorem.** If two smooth knots
$K_1, K_2 : S^1 \hookrightarrow S^3$ have homeomorphic complements
$S^3 \setminus K_1(S^1) \simeq_{\mathrm{top}} S^3 \setminus K_2(S^1)$, then
there exists a smooth self-diffeomorphism of $S^3$ carrying $K_1(S^1)$ onto
$K_2(S^1)$. -/
@[eval_problem]
theorem gordon_luecke_knot_complement
    (K₁ K₂ : TauCeti.SmoothCircleEmbedding (𝓡 3) (sphere (0 : EuclideanSpace ℝ (Fin 4)) 1))
    (e : ↥(range (K₁ : Circle → sphere (0 : EuclideanSpace ℝ (Fin 4)) 1))ᶜ ≃ₜ
      ↥(range (K₂ : Circle → sphere (0 : EuclideanSpace ℝ (Fin 4)) 1))ᶜ) :
    ∃ φ : sphere (0 : EuclideanSpace ℝ (Fin 4)) 1 ≃ₘ⟮𝓡 3, 𝓡 3⟯
        sphere (0 : EuclideanSpace ℝ (Fin 4)) 1,
      φ '' range (K₁ : Circle → sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) =
        range (K₂ : Circle → sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) := by
  sorry

end Topology
end LeanEval
