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
# Freedman's Classification of Simply Connected Topological $4$-Manifolds (At Most Two Types)

Michael H. Freedman (1982, *The topology of four-dimensional manifolds*, *J.
Differential Geom.* 17, 357–453, Theorem 1.5; see also Freedman–Quinn, *Topology
of 4-Manifolds*, Princeton Math. Ser. 39, 1990, Theorem 10.1; Fields Medal 1986)
proved that every unimodular symmetric integral bilinear form is realized by at
most two homeomorphism types of closed simply connected oriented topological
$4$-manifolds: a unique type in the even case, and exactly two types
(distinguished by the Kirby–Siebenmann triangulation obstruction in
$\mathbb{Z}/2\mathbb{Z}$) in the odd case.
-/

namespace FreedmanFourManifoldAtMostTwo

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

end FreedmanFourManifoldAtMostTwo

/-- **Freedman's at-most-two homeomorphism types theorem.** Given any three
closed simply connected oriented topological $4$-manifolds with pairwise
isometric integral intersection forms, at least two of them are homeomorphic. -/
@[eval_problem]
theorem freedman_four_manifold_at_most_two
    {M₁ M₂ M₃ : Type}
    [TopologicalSpace M₁] [T2Space M₁] [CompactSpace M₁] [SimplyConnectedSpace M₁]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M₁]
    [TopologicalSpace M₂] [T2Space M₂] [CompactSpace M₂] [SimplyConnectedSpace M₂]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M₂]
    [TopologicalSpace M₃] [T2Space M₃] [CompactSpace M₃] [SimplyConnectedSpace M₃]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M₃]
    (o₁ : TauCeti.HomologicalOrientation M₁ (EuclideanSpace ℝ (Fin 4)) 4)
    (o₂ : TauCeti.HomologicalOrientation M₂ (EuclideanSpace ℝ (Fin 4)) 4)
    (o₃ : TauCeti.HomologicalOrientation M₃ (EuclideanSpace ℝ (Fin 4)) 4)
    (h₁₂ : Nonempty
      ((FreedmanFourManifoldAtMostTwo.intersectionForm o₁).IsometryEquiv
        (FreedmanFourManifoldAtMostTwo.intersectionForm o₂)))
    (h₁₃ : Nonempty
      ((FreedmanFourManifoldAtMostTwo.intersectionForm o₁).IsometryEquiv
        (FreedmanFourManifoldAtMostTwo.intersectionForm o₃))) :
    Nonempty (M₁ ≃ₜ M₂) ∨ Nonempty (M₁ ≃ₜ M₃) ∨ Nonempty (M₂ ≃ₜ M₃) := by
  sorry

end Topology
end LeanEval
