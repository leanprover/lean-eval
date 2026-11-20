import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.BilinearForm.Properties
import TauCeti.AlgebraicTopology.Cohomology.FundamentalClass
import TauCeti.AlgebraicTopology.Cohomology.IntegralCup
import EvalTools.Markers

open CategoryTheory

namespace LeanEval
namespace Topology

/-!
# Freedman's Homeomorphism Classification of Even Simply Connected $4$-Manifolds

Michael H. Freedman (1982, *The topology of four-dimensional manifolds*, *J.
Differential Geom.* 17, 357–453, Theorem 1.5; Fields Medal 1986) proved via his
topological $h$-cobordism theorem and disk-embedding theorem for Casson handles
that any two closed simply connected oriented topological $4$-manifolds with
isometric even intersection forms are homeomorphic (including in particular the
four-dimensional topological Poincaré conjecture when the intersection form is
zero).
-/

namespace FreedmanFourManifoldEvenClassification

/-- The integral intersection form $Q_M(\alpha, \beta) = \langle \alpha \smile \beta, [M] \rangle$
on $H^2(M; \mathbb{Z})$ of a closed homologically oriented topological $4$-manifold $(M, o)$. -/
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

end FreedmanFourManifoldEvenClassification

/-- **Freedman's classification theorem for even intersection forms.** Any two
closed simply connected oriented topological $4$-manifolds with isometric even
integral intersection forms are homeomorphic. -/
@[eval_problem]
theorem freedman_four_manifold_even_classification
    {M₁ M₂ : Type}
    [TopologicalSpace M₁] [T2Space M₁] [CompactSpace M₁] [SimplyConnectedSpace M₁]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M₁]
    [TopologicalSpace M₂] [T2Space M₂] [CompactSpace M₂] [SimplyConnectedSpace M₂]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M₂]
    (o₁ : TauCeti.HomologicalOrientation M₁ (EuclideanSpace ℝ (Fin 4)) 4)
    (o₂ : TauCeti.HomologicalOrientation M₂ (EuclideanSpace ℝ (Fin 4)) 4)
    (heven : ∀ x, Even (FreedmanFourManifoldEvenClassification.intersectionForm o₁ x x))
    (hiso : Nonempty
      ((FreedmanFourManifoldEvenClassification.intersectionForm o₁).IsometryEquiv
        (FreedmanFourManifoldEvenClassification.intersectionForm o₂))) :
    Nonempty (M₁ ≃ₜ M₂) := by
  sorry

end Topology
end LeanEval
