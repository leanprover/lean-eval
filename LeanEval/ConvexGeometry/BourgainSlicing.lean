import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Set
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import EvalTools.Markers

open MeasureTheory

namespace LeanEval
namespace ConvexGeometry

/-!
# Klartag–Lehec Resolution of Bourgain's Slicing Problem

Jean Bourgain (1986, *On high-dimensional maximal functions associated to convex
bodies*, *Amer. J. Math.* 108, 1467–1476) asked whether every convex body
$K \subset \mathbb{R}^n$ of unit volume admits an affine hyperplane section of
$(n - 1)$-dimensional volume bounded below by a universal constant $c > 0$,
equivalently whether the affine-invariant *isotropic constant*
$$
  L_K = \frac{(\det \operatorname{Cov}(K))^{1/(2n)}}{\operatorname{vol}_n(K)^{1/n}}
$$
is bounded above by a universal constant $C > 0$ independent of the dimension
$n$ and the convex body $K$. Building on Eldan's stochastic localization,
the Kannan–Lovász–Simonovits (KLS) isoperimetric framework, and Qingyang Guan's
bound $L_K \le C \log \log n$ (arXiv:2412.09075, 2024), Bo'az Klartag and
Joseph Lehec (2025, *Affirmative resolution of Bourgain's slicing problem using
Guan's bound*, *Geom. Funct. Anal.* 35, 1147–1168, arXiv:2412.15044,
Theorem 1.1) proved that $L_K \le C$ for a universal constant $C > 0$.
-/

namespace BourgainSlicing

/-- The barycenter (centroid) $|K|^{-1} \int_K x\,dx$ of $K \subseteq \mathbb{R}^n$. -/
noncomputable def barycenter {n : ℕ} (K : Set (EuclideanSpace ℝ (Fin n))) :
    EuclideanSpace ℝ (Fin n) :=
  (volume.real K)⁻¹ • ∫ x in K, x

/-- The covariance matrix
$\operatorname{Cov}(K)_{ij} = |K|^{-1} \int_K (x_i - b_i)(x_j - b_j)\,dx$ of the
uniform probability measure on $K \subseteq \mathbb{R}^n$, where $b = b(K)$ is
the barycenter. -/
noncomputable def covarianceMatrix {n : ℕ} (K : Set (EuclideanSpace ℝ (Fin n))) :
    Matrix (Fin n) (Fin n) ℝ :=
  Matrix.of fun i j ↦
    (volume.real K)⁻¹ * ∫ x in K, (x i - barycenter K i) * (x j - barycenter K j)

/-- The isotropic constant
$L_K = (\det \operatorname{Cov}(K))^{1/(2n)} / \operatorname{vol}_n(K)^{1/n}$ of a
convex body $K \subseteq \mathbb{R}^n$. -/
noncomputable def isotropicConstant {n : ℕ} (K : Set (EuclideanSpace ℝ (Fin n))) : ℝ :=
  (covarianceMatrix K).det ^ (1 / (2 * (n : ℝ))) / (volume.real K) ^ (1 / (n : ℝ))

end BourgainSlicing

/-- **Klartag–Lehec theorem (Bourgain's slicing conjecture).** There exists a
universal constant $C > 0$ such that for every dimension $n \ge 1$ and every
convex body (compact convex set with nonempty interior) $K \subset \mathbb{R}^n$,
the isotropic constant satisfies $L_K \le C$. -/
@[eval_problem]
theorem klartag_lehec_bourgain_slicing :
    ∃ C : ℝ, 0 < C ∧
      ∀ (n : ℕ), 0 < n →
        ∀ K : Set (EuclideanSpace ℝ (Fin n)),
          Convex ℝ K → IsCompact K → (interior K).Nonempty →
            BourgainSlicing.isotropicConstant K ≤ C := by
  sorry

end ConvexGeometry
end LeanEval
