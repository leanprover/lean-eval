import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Geometry.Manifold.Instances.Real
import Mathlib.LinearAlgebra.BilinearForm.TensorProduct
import TauCeti.AlgebraicTopology.Cohomology.FundamentalClass
import TauCeti.AlgebraicTopology.Cohomology.IntegralCup
import TauCeti.LinearAlgebra.QuadraticForm.Signature
import EvalTools.Markers

open CategoryTheory QuadraticMap
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

/-!
# Rokhlin's Signature Theorem for Smooth Spin $4$-Manifolds

Vladimir A. Rokhlin (1952, *New results in the theory of four-dimensional
manifolds*, *Dokl. Akad. Nauk SSSR* 84, 221–224) proved that the signature
$\sigma(M) = b_2^+(M) - b_2^-(M)$ of every closed smooth spin $4$-manifold is
divisible by $16$ (sharpening the purely algebraic divisibility $8 \mid \sigma$
for even unimodular symmetric integral bilinear forms and showing, in
particular, that the $E_8$ lattice of signature $8$ is not realized by any
closed simply connected smooth $4$-manifold). For a simply connected closed
oriented smooth $4$-manifold, being spin is equivalent (via Wu's formula) to
having even intersection form.
-/

namespace RokhlinSignature

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

/-- Signature $\sigma(M) = b_2^+(M) - b_2^-(M) \in \mathbb{Z}$ of the
rationalized intersection form on $\mathbb{Q} \otimes_{\mathbb{Z}} H^2(M; \mathbb{Z})$. -/
noncomputable def signature
    {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4) : ℤ :=
  (sigPos ((intersectionForm o).baseChange ℚ).toQuadraticMap : ℤ) -
    (sigNeg ((intersectionForm o).baseChange ℚ).toQuadraticMap : ℤ)

end RokhlinSignature

/-- **Rokhlin's signature theorem.** For every closed simply connected oriented
smooth $4$-manifold $(M, o)$ with even intersection form, the signature
$\sigma(M)$ is divisible by $16$. -/
@[eval_problem]
theorem rokhlin_signature
    {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M] [SimplyConnectedSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M] [IsManifold (𝓡 4) ∞ M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4)
    (heven : ∀ x, Even (RokhlinSignature.intersectionForm o x x)) :
    (16 : ℤ) ∣ RokhlinSignature.signature o := by
  sorry

end Topology
end LeanEval
