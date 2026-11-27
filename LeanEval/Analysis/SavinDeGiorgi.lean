import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import EvalTools.Markers

open Filter
open scoped InnerProductSpace Laplacian Real Topology

namespace LeanEval
namespace Analysis

/-!
# Savin's Theorem on De Giorgi's Conjecture in Dimensions $1 \le n \le 8$

Ennio De Giorgi (1978, *Convergence problems for functionals and operators*,
Proc. Int. Meeting on Recent Methods in Nonlinear Analysis, Pitagora, 131–188)
conjectured that entire bounded solutions $u \in C^2(\mathbb{R}^n)$ to the
Allen–Cahn equation $-\Delta u = u - u^3$ with $|u| \le 1$ and
$\partial_{x_n} u > 0$ are one-dimensional in dimensions $n \le 8$ (previously
established for $n = 2$ by Ghoussoub–Gui 1998 and for $n = 3$ by
Ambrosio–Cabré 2000). Ovidiu Savin (2009, *Regularity of flat level sets in
phase transitions*, *Ann. of Math.* (2) 169, 41–78, Theorem 1.2) proved
De Giorgi's conjecture for all $1 \le n \le 8$ under the additional asymptotic
profile condition $\lim_{x_n \to \pm\infty} u(x', x_n) = \pm 1$.
-/

namespace SavinDeGiorgi

/-- One-dimensional Allen–Cahn transition profile
$x \mapsto \tanh\!\big((\langle e, x \rangle - c) / \sqrt{2}\big)$. -/
noncomputable def allenCahnPlanarWave {n : ℕ}
    (e : EuclideanSpace ℝ (Fin n)) (c : ℝ) (x : EuclideanSpace ℝ (Fin n)) : ℝ :=
  Real.tanh ((⟪e, x⟫_ℝ - c) / √2)

end SavinDeGiorgi

/-- **Savin's theorem on De Giorgi's conjecture ($1 \le n \le 8$).** Every
bounded $C^2$ solution $u : \mathbb{R}^n \to \mathbb{R}$ ($1 \le n \le 8$) to
$-\Delta u = u - u^3$ that is strictly increasing in a unit direction $\nu$ and
tends pointwise to $\pm 1$ along every line $s \mapsto x + s \nu$ as
$s \to \pm\infty$ is a one-dimensional planar wave
$u(x) = \tanh\!\big((\langle e, x \rangle - c) / \sqrt{2}\big)$ for some unit
vector $e$ with $\langle e, \nu \rangle > 0$ and shift $c \in \mathbb{R}$. -/
@[eval_problem]
theorem savin_de_giorgi_conjecture {n : ℕ} (hn₁ : 1 ≤ n) (hn₈ : n ≤ 8)
    {u : EuclideanSpace ℝ (Fin n) → ℝ} (hu_reg : ContDiff ℝ 2 u)
    (hu_bdd : ∀ x : EuclideanSpace ℝ (Fin n), |u x| ≤ 1)
    (hu_pde : ∀ x : EuclideanSpace ℝ (Fin n), -Δ u x = u x - u x ^ 3)
    {ν : EuclideanSpace ℝ (Fin n)} (hν : ‖ν‖ = 1)
    (hu_mono : ∀ x : EuclideanSpace ℝ (Fin n), 0 < fderiv ℝ u x ν)
    (hu_top : ∀ x : EuclideanSpace ℝ (Fin n), Tendsto (fun s : ℝ ↦ u (x + s • ν)) atTop (𝓝 1))
    (hu_bot : ∀ x : EuclideanSpace ℝ (Fin n), Tendsto (fun s : ℝ ↦ u (x + s • ν)) atBot (𝓝 (-1))) :
    ∃ (e : EuclideanSpace ℝ (Fin n)) (c : ℝ),
      ‖e‖ = 1 ∧ 0 < ⟪e, ν⟫_ℝ ∧
        ∀ x : EuclideanSpace ℝ (Fin n), u x = SavinDeGiorgi.allenCahnPlanarWave e c x := by
  sorry

end Analysis
end LeanEval
