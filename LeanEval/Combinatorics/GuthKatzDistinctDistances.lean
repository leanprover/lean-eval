import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import EvalTools.Markers

namespace LeanEval
namespace Combinatorics

/-!
# The Guth–Katz Planar Distinct Distances Theorem

Paul Erdős (1946, *On sets of distances of $n$ points*, *Amer. Math. Monthly*
53, 248–250) asked for the minimum number of distinct Euclidean distances
determined by $n$ points in $\mathbb{R}^2$, noting that a
$\sqrt{n} \times \sqrt{n}$ integer grid determines
$O(n / \sqrt{\log n})$ distinct distances. Larry Guth and Nets Hawk Katz (2015,
*On the Erdős distinct distances problem in the plane*, *Ann. of Math.* (2) 181,
155–190, Theorem 1.1) resolved Erdős's conjecture up to a $\sqrt{\log n}$ factor
by proving that every finite set $P \subset \mathbb{R}^2$ of cardinality
$|P| \ge 2$ determines at least $c |P| / \log |P|$ distinct positive distances,
for an absolute constant $c > 0$.
-/

namespace GuthKatzDistinctDistances

/-- The finite set $\{\|p - q\| : p, q \in P,\, p \ne q\}$ of distinct positive
Euclidean distances determined by a finite planar point set `P`. -/
noncomputable def distinctDistances (P : Finset (EuclideanSpace ℝ (Fin 2))) : Finset ℝ := by
  classical
  exact P.offDiag.image fun pq ↦ dist pq.1 pq.2

end GuthKatzDistinctDistances

/-- **Guth–Katz distinct distances theorem.** There exists an absolute constant
$c > 0$ such that every finite set $P \subset \mathbb{R}^2$ with $|P| \ge 2$
determines at least $c |P| / \log |P|$ distinct positive distances. -/
@[eval_problem]
theorem guth_katz_distinct_distances :
    ∃ c : ℝ, 0 < c ∧
      ∀ P : Finset (EuclideanSpace ℝ (Fin 2)), 2 ≤ P.card →
        c * (P.card : ℝ) / Real.log (P.card : ℝ) ≤
          ((GuthKatzDistinctDistances.distinctDistances P).card : ℝ) := by
  sorry

end Combinatorics
end LeanEval
