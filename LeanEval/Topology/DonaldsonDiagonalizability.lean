import Mathlib.Algebra.Module.Torsion.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Geometry.Manifold.Instances.Real
import Mathlib.LinearAlgebra.BilinearForm.Basic
import TauCeti.AlgebraicTopology.Cohomology.FundamentalClass
import TauCeti.AlgebraicTopology.Cohomology.IntegralCup
import EvalTools.Markers

open CategoryTheory
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

/-!
# Donaldson's Diagonalizability Theorem for Smooth $4$-Manifolds

Simon K. Donaldson (1983, *An application of gauge theory to four-dimensional
topology*, *J. Differential Geom.* 18, 279–315; 1987, *The orientation of
Yang–Mills moduli spaces and $4$-manifold topology*, *J. Differential Geom.* 26,
397–428; Fields Medal 1986) proved via the moduli space of anti-self-dual
$\mathrm{SU}(2)$ Yang–Mills instantons that if a closed connected oriented
smooth $4$-manifold $(M, o)$ has positive-definite intersection form on
$H^2(M; \mathbb{Z}) / \mathrm{Tors}$, then that form is isometric over
$\mathbb{Z}$ to the standard diagonal form $\sum_{i=1}^n x_i y_i$ on
$\mathbb{Z}^n$ (without any assumption on $\pi_1(M)$).
-/

namespace DonaldsonDiagonalizability

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

end DonaldsonDiagonalizability

/-- **Donaldson's diagonalizability theorem.** If a closed connected oriented
smooth $4$-manifold $(M, o)$ has positive-definite intersection form modulo
torsion ($Q_M(\alpha, \alpha) > 0$ for every non-torsion class
$\alpha \in H^2(M; \mathbb{Z})$), then $(H^2(M; \mathbb{Z}) / \mathrm{Tors}, Q_M)$
is isometric over $\mathbb{Z}$ to the standard diagonal lattice
$(\mathbb{Z}^n, \sum_{i=1}^n x_i y_i)$ for some $n \in \mathbb{N}$: there exists
a surjective $\mathbb{Z}$-linear map $f : H^2(M; \mathbb{Z}) \to \mathbb{Z}^n$
with kernel $\mathrm{Tors}(H^2(M; \mathbb{Z}))$ such that
$Q_M(\alpha, \beta) = \sum_{i=1}^n f(\alpha)_i f(\beta)_i$ for all
$\alpha, \beta \in H^2(M; \mathbb{Z})$. -/
@[eval_problem]
theorem donaldson_diagonalizability
    {M : Type} [TopologicalSpace M] [T2Space M] [CompactSpace M] [ConnectedSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) M] [IsManifold (𝓡 4) ∞ M]
    (o : TauCeti.HomologicalOrientation M (EuclideanSpace ℝ (Fin 4)) 4)
    (hpos : ∀ α : (TopCat.of M).integralCohomology 2,
      α ∉ Submodule.torsion ℤ ((TopCat.of M).integralCohomology 2) →
      0 < DonaldsonDiagonalizability.intersectionForm o α α) :
    ∃ (n : ℕ) (f : (TopCat.of M).integralCohomology 2 →ₗ[ℤ] (Fin n → ℤ)),
      Function.Surjective f ∧
      LinearMap.ker f = Submodule.torsion ℤ ((TopCat.of M).integralCohomology 2) ∧
      ∀ α β : (TopCat.of M).integralCohomology 2,
        DonaldsonDiagonalizability.intersectionForm o α β =
          ∑ i : Fin n, f α i * f β i := by
  sorry

end Topology
end LeanEval
