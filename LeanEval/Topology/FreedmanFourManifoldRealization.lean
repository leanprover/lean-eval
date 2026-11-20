import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.BilinearForm.Properties
import TauCeti.AlgebraicTopology.Cohomology.FundamentalClass
import TauCeti.AlgebraicTopology.Cohomology.IntegralCup
import TauCeti.LinearAlgebra.IntegralLattice.Unimodular
import EvalTools.Markers

open CategoryTheory

namespace LeanEval
namespace Topology

/-!
# Freedman's Realization Theorem for Simply Connected Topological $4$-Manifolds

Michael H. Freedman (1982, *The topology of four-dimensional manifolds*, *J.
Differential Geom.* 17, 357–453, Theorem 1.5; Fields Medal 1986) proved using
infinite Casson handles that every unimodular symmetric integral bilinear form
(even or odd, definite or indefinite — including non-diagonalizable forms such
as $E_8$) is realized as the intersection form of a closed simply connected
oriented topological $4$-manifold.
-/

namespace FreedmanFourManifoldRealization

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

end FreedmanFourManifoldRealization

/-- **Freedman's realization theorem.** Every unimodular symmetric integral
lattice $L$ is realized as the integral intersection form of a closed simply
connected oriented topological $4$-manifold. -/
@[eval_problem]
theorem freedman_four_manifold_realization
    {V : Type} [AddCommGroup V] [Module ℚ V] (L : TauCeti.IntegralLattice V)
    (hU : L.IsUnimodular) :
    ∃ (M : Type) (_ : TopologicalSpace M) (_ : T2Space M) (_ : CompactSpace M)
      (_ : SimplyConnectedSpace M) (_ : ChartedSpace (EuclideanSpace ℝ (Fin 4)) M)
      (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4),
      Nonempty
        ((FreedmanFourManifoldRealization.intersectionForm o).IsometryEquiv L.integralForm) := by
  sorry

end Topology
end LeanEval
