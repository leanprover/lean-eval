import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Geometry.Manifold.Instances.Real
import Mathlib.LinearAlgebra.BilinearForm.TensorProduct
import TauCeti.AlgebraicTopology.Cohomology.FundamentalClass
import TauCeti.AlgebraicTopology.Cohomology.IntegralCup
import TauCeti.LinearAlgebra.QuadraticForm.Signature
import EvalTools.Markers

open CategoryTheory QuadraticMap TensorProduct
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

/-!
# Furuta's $10/8$ Theorem for Smooth Spin $4$-Manifolds

Mikio Furuta (2001, *Monopole equation and the $\frac{11}{8}$-conjecture*,
*Math. Res. Lett.* 8, 279–291, Theorem 1) proved using $\mathrm{Pin}(2)$-equivariant
$K$-theory applied to finite-dimensional Bauer–Furuta approximations of the
Seiberg–Witten monopole map that every closed smooth spin $4$-manifold $M$ with
indefinite intersection form satisfies
$$
  b_2(M) \ge \frac{10}{8} |\sigma(M)| + 2,
$$
i.e. $10 |\sigma(M)| + 16 \le 8 b_2(M)$ (attained with equality on
$S^2 \times S^2$, where $\sigma = 0, b_2 = 2$, and on the $K3$ surface, where
$|\sigma| = 16, b_2 = 22$). For a closed simply connected oriented smooth
$4$-manifold, the existence of a spin structure is equivalent to having even
intersection form.
-/

namespace FurutaTenEighths

/-- The integral intersection form $Q_M(\alpha, \beta) = \langle \alpha \smile \beta, [M] \rangle$
on $H^2(M; \mathbb{Z})$ of a closed homologically oriented $4$-manifold $(M, o)$. -/
noncomputable def intersectionForm
    {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4) :
    LinearMap.BilinForm ℤ ((TopCat.of M).integralCohomology 2) :=
  LinearMap.mk₂ ℤ
    (fun α β ↦
      o.evalFundamentalClass (finrank_euclideanSpace_fin (𝕜 := ℝ) (n := 4))
        (ModuleCat.of ℤ ℤ) (ContinuousMap.id M)
        ((TopCat.of M).integralCup 2 2 4 rfl α β))
    (fun _ _ _ ↦ by simp) (fun _ _ _ ↦ by simp)
    (fun _ _ _ ↦ by simp) (fun _ _ _ ↦ by simp)

/-- Positive index of inertia $b_2^+(M)$ of the rationalized intersection form. -/
noncomputable def b2Pos {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4) : ℕ :=
  sigPos ((intersectionForm o).baseChange ℚ).toQuadraticMap

/-- Negative index of inertia $b_2^-(M)$ of the rationalized intersection form. -/
noncomputable def b2Neg {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4) : ℕ :=
  sigNeg ((intersectionForm o).baseChange ℚ).toQuadraticMap

/-- Second Betti number $b_2(M) = \dim_{\mathbb{Q}}(\mathbb{Q} \otimes_{\mathbb{Z}} H^2(M; \mathbb{Z}))$. -/
noncomputable def b2 (M : Type) [TopologicalSpace M] : ℕ :=
  Module.finrank ℚ (ℚ ⊗[ℤ] (TopCat.of M).integralCohomology 2)

/-- Signature $\sigma(M) = b_2^+(M) - b_2^-(M) \in \mathbb{Z}$. -/
noncomputable def signature {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4) : ℤ :=
  (b2Pos o : ℤ) - (b2Neg o : ℤ)

end FurutaTenEighths

/-- **Furuta's $10/8$ theorem.** For every closed simply connected oriented
smooth $4$-manifold $(M, o)$ with even indefinite intersection form
($b_2^+(M) > 0$ and $b_2^-(M) > 0$), $10 |\sigma(M)| + 16 \le 8 b_2(M)$. -/
@[eval_problem]
theorem furuta_ten_eighths
    {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M] [SimplyConnectedSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M] [IsManifold (𝓡 4) ∞ M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4)
    (heven : ∀ x, Even (FurutaTenEighths.intersectionForm o x x))
    (hpos : 0 < FurutaTenEighths.b2Pos o) (hneg : 0 < FurutaTenEighths.b2Neg o) :
    10 * |FurutaTenEighths.signature o| + 16 ≤ 8 * (FurutaTenEighths.b2 M : ℤ) := by
  sorry

end Topology
end LeanEval
