import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Geometry.Manifold.Diffeomorph
import Mathlib.Geometry.Manifold.Instances.Real
import Mathlib.LinearAlgebra.BilinearForm.Properties
import Mathlib.LinearAlgebra.Matrix.BilinearForm
import TauCeti.AlgebraicTopology.Cohomology.FundamentalClass
import TauCeti.AlgebraicTopology.Cohomology.IntegralCup
import EvalTools.Markers

open CategoryTheory
open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

/-!
# Fintushel–Stern Infinitely Many Exotic Smooth Structures on $K3$

Ronald Fintushel and Ronald J. Stern (1998, *Knots, links, and $4$-manifolds*,
*Invent. Math.* 134, 363–400, Theorem 1.1 and Corollary 1.2) introduced knot
surgery along a regular torus fiber of an elliptic fibration on a $K3$ surface,
constructing for each knot $K \subset S^3$ a closed simply connected smooth
$4$-manifold $K3_K$ homeomorphic to $K3$ (by Freedman's classification) whose
Seiberg–Witten invariant equals the symmetrized Alexander polynomial
$\Delta_K(t)$. Varying $K$ over knots with pairwise distinct Alexander
polynomials yields infinitely many pairwise homeomorphic, pairwise
non-diffeomorphic smooth structures on any smooth $K3$ manifold (a closed simply
connected smooth $4$-manifold with intersection form $-E_8 \oplus -E_8 \oplus 3H$).
-/

namespace FintushelSternExoticK3

/-- The integral intersection form $Q_X(\alpha, \beta) = \langle \alpha \smile \beta, [X] \rangle$
on $H^2(X; \mathbb{Z})$ of a closed homologically oriented $4$-manifold $(X, o)$. -/
noncomputable def intersectionForm
    {X : Type} [TopologicalSpace X] [T2Space X] [CompactSpace X]
    [ChartedSpace (EuclideanSpace ℝ (Fin 4)) X]
    (o : TauCeti.HomologicalOrientation X (EuclideanSpace ℝ (Fin 4)) 4) :
    LinearMap.BilinForm ℤ ((TopCat.of X).integralCohomology 2) :=
  LinearMap.mk₂ ℤ
    (fun α β ↦
      o.evalFundamentalClass (finrank_euclideanSpace_fin (𝕜 := ℝ) (n := 4))
        (ModuleCat.of ℤ ℤ) (ContinuousMap.id X)
        ((TopCat.of X).integralCup 2 2 4 rfl α β))
    (fun _ _ _ ↦ by simp) (fun _ _ _ ↦ by simp)
    (fun _ _ _ ↦ by simp) (fun _ _ _ ↦ by simp)

/-- The positive-definite $E_8$ Cartan matrix on `Fin 8`, with chain
`0 — 1 — 2 — 3 — 4 — 5 — 6` and branch `2 — 7`. -/
def e8Cartan : Matrix (Fin 8) (Fin 8) ℤ :=
  !![ 2, -1,  0,  0,  0,  0,  0,  0;
     -1,  2, -1,  0,  0,  0,  0,  0;
      0, -1,  2, -1,  0,  0,  0, -1;
      0,  0, -1,  2, -1,  0,  0,  0;
      0,  0,  0, -1,  2, -1,  0,  0;
      0,  0,  0,  0, -1,  2, -1,  0;
      0,  0,  0,  0,  0, -1,  2,  0;
      0,  0, -1,  0,  0,  0,  0,  2]


/-- The hyperbolic plane Gram matrix $H = \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix}$. -/
def hyperbolicPlane : Matrix (Fin 2) (Fin 2) ℤ := !![0, 1; 1, 0]

/-- Index type for the rank-$22$ $K3$ lattice $(-E_8) \oplus (-E_8) \oplus H^{\oplus 3}$. -/
abbrev K3Index : Type := (Fin 8 ⊕ Fin 8) ⊕ (Fin 3 × Fin 2)

/-- Gram matrix of the even unimodular $K3$ intersection form
$(-E_8) \oplus (-E_8) \oplus 3H$ of rank $22$ and signature $-16$. -/
def k3GramMatrix : Matrix K3Index K3Index ℤ :=
  Matrix.fromBlocks
    (Matrix.fromBlocks (-e8Cartan) 0 0 (-e8Cartan)) 0
    0 (Matrix.of fun (a, i) (b, j) ↦ if a = b then hyperbolicPlane i j else 0)

/-- The $K3$ integral bilinear form $(-E_8) \oplus (-E_8) \oplus 3H$. -/
def k3IntersectionForm : LinearMap.BilinForm ℤ (K3Index → ℤ) :=
  k3GramMatrix.toBilin'

/-- A bundled smooth $4$-manifold (without boundary) in `Type`. -/
structure SmoothFourManifold where
  /-- Underlying point set. -/
  Carrier : Type
  /-- Underlying topology. -/
  [topologicalSpace : TopologicalSpace Carrier]
  /-- Hausdorff separation. -/
  [t2Space : T2Space Carrier]
  /-- Smooth $4$-manifold chart atlas. -/
  [chartedSpace : ChartedSpace (EuclideanSpace ℝ (Fin 4)) Carrier]
  /-- $C^\infty$ smoothness of chart transitions. -/
  [isManifold : IsManifold (𝓡 4) ∞ Carrier]

attribute [instance] SmoothFourManifold.topologicalSpace SmoothFourManifold.t2Space
  SmoothFourManifold.chartedSpace SmoothFourManifold.isManifold

end FintushelSternExoticK3

/-- **Fintushel–Stern exotic $K3$ surfaces theorem.** Every closed simply
connected smooth $4$-manifold whose integral intersection form (for some
orientation) is isometric to $(-E_8) \oplus (-E_8) \oplus 3H$ admits an
infinite sequence of smooth $4$-manifolds homeomorphic to it and pairwise not
$C^\infty$-diffeomorphic. -/
@[eval_problem]
theorem fintushel_stern_exotic_k3
    (X : Type) [TopologicalSpace X] [T2Space X] [CompactSpace X]
    [SimplyConnectedSpace X] [ChartedSpace (EuclideanSpace ℝ (Fin 4)) X]
    [IsManifold (𝓡 4) ∞ X]
    (hK3 : ∃ o : TauCeti.HomologicalOrientation X (EuclideanSpace ℝ (Fin 4)) 4,
      Nonempty ((FintushelSternExoticK3.intersectionForm o).IsometryEquiv
        FintushelSternExoticK3.k3IntersectionForm)) :
    ∃ Y : ℕ → FintushelSternExoticK3.SmoothFourManifold,
      (∀ i : ℕ, Nonempty (X ≃ₜ (Y i).Carrier)) ∧
      (∀ i j : ℕ, i ≠ j → IsEmpty (Diffeomorph (𝓡 4) (𝓡 4) (Y i).Carrier (Y j).Carrier ∞)) := by
  sorry

end Topology
end LeanEval
