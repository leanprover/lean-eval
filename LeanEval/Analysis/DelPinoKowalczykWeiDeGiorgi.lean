import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.Analysis.InnerProductSpace.PiL2
import EvalTools.Markers

open Filter
open scoped InnerProductSpace Laplacian Topology

namespace LeanEval
namespace Analysis

/-!
# The del Pino–Kowalczyk–Wei Counterexample to De Giorgi's Conjecture ($n \ge 9$)

Manuel del Pino, Michał Kowalczyk, and Juncheng Wei (2011, *On De Giorgi's
conjecture in dimension $N \ge 9$*, *Ann. of Math.* (2) 174, 1485–1569,
Theorem 1) showed that the dimensional threshold $n \le 8$ in De Giorgi's
conjecture (1978) and Savin's theorem (2009) is sharp: in every dimension
$n \ge 9$, there exists a bounded smooth solution $u : \mathbb{R}^n \to (-1, 1)$
to the Allen–Cahn equation $-\Delta u = u - u^3$ (constructed with nodal set
modeled on a Bombieri–De Giorgi–Giusti entire non-planar minimal graph) that is
strictly increasing in a unit direction $\nu$, satisfies the pointwise limits
$\lim_{s \to \pm\infty} u(x + s \nu) = \pm 1$ for every $x \in \mathbb{R}^n$,
and yet is not one-dimensional.
-/

/-- **The del Pino–Kowalczyk–Wei counterexample to De Giorgi's conjecture.** In
every dimension $n \ge 9$ and for every unit vector $\nu \in \mathbb{R}^n$,
there exists a $C^2$ solution $u : \mathbb{R}^n \to (-1, 1)$ to
$-\Delta u = u - u^3$ strictly increasing along $\nu$ with pointwise limits
$\pm 1$ as $s \to \pm\infty$ along every line $x + s \nu$ that is not a function
of a single linear coordinate $\langle e, x \rangle$. -/
@[eval_problem]
theorem del_pino_kowalczyk_wei_de_giorgi {n : ℕ} (hn : 9 ≤ n)
    {ν : EuclideanSpace ℝ (Fin n)} (hν : ‖ν‖ = 1) :
    ∃ u : EuclideanSpace ℝ (Fin n) → ℝ,
      ContDiff ℝ 2 u ∧
      (∀ x : EuclideanSpace ℝ (Fin n), |u x| < 1) ∧
      (∀ x : EuclideanSpace ℝ (Fin n), -Δ u x = u x - u x ^ 3) ∧
      (∀ x : EuclideanSpace ℝ (Fin n), 0 < fderiv ℝ u x ν) ∧
      (∀ x : EuclideanSpace ℝ (Fin n), Tendsto (fun s : ℝ ↦ u (x + s • ν)) atTop (𝓝 1)) ∧
      (∀ x : EuclideanSpace ℝ (Fin n), Tendsto (fun s : ℝ ↦ u (x + s • ν)) atBot (𝓝 (-1))) ∧
      ¬ ∃ (e : EuclideanSpace ℝ (Fin n)) (g : ℝ → ℝ),
          ∀ x : EuclideanSpace ℝ (Fin n), u x = g ⟪e, x⟫_ℝ := by
  sorry

end Analysis
end LeanEval
