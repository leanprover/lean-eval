import Mathlib
import EvalTools.Markers

/-!
# Smallness of exceptional set to Littlewood's conjecture

Littlewood conjectured in the 1930s that liminf_{n→∞} n⟨nα⟩⟨nβ⟩=0 for any real numbers
α and β, where ⟨x⟩ is the distance from x to the nearest integer.

In 2003, Einsiedler, Katok and Lindenstrauss used ergodic methods to prove that the set of
exceptions to Littlewood’s conjecture is extremely small (has zero Hausdorff dimension).

The proof relies on a partial classification of certain invariant measures on SL₃(ℤ)\SL₃(ℝ).
This is part of the theory of measure rigidity, and the particular type of phenomenon seen
has its origins in work of Furstenberg. A special case of far-reaching conjectures by Margulis,
by Furstenberg, and by Katok concerns actions of the group A of positive diagonal matrices in
SLₖ(ℝ) for k ⩾ 3 on the space SLₖ(ℤ)\SLₖ(ℝ): if µ is an A-invariant ergodic probability measure
on this space, then it is homogeneous in the sense that there a closed connected group L ⩾ A
for which µ is the unique L-invariant measure on a single closed L-orbit. The work of Einsiedler,
Katok and Lindenstrauss proved this conjecture under the additional hypothesis that the measure
µ gives positive entropy to some one-parameter subgroup of A, which leads to the stated theorem.

## References

* M. Einsiedler, A. Katok, and E. Lindenstrauss, ‘Invariant measures and the set of
  exceptions to Littlewood’s conjecture’, Ann. of Math. (2) 164 (2006), no. 2, 513–560.

* Venkatesh, Akshay (2008). "The work of Einsiedler, Katok and Lindenstrauss on the Littlewood
  conjecture". Bulletin of the American Mathematical Society. 45 (1): 117–134.
  https://doi.org/10.1090/S0273-0979-07-01194-9.

* Manfred Einsiedler, Thomas Ward. Ergodic Theory: with a view towards Number Theory (GTM 259).
  London: Springer. 2010. https://doi.org/10.1007/978-0-85729-021-2
-/

namespace LeanEval.Dynamics.EinsiedlerKatokLindenstrauss

/-- The distance from a real number to the nearest integer. -/
noncomputable def distToNearestInt (x : ℝ) : ℝ := |x - round x|

@[eval_problem]
theorem einsiedler_katok_lindenstrauss :
    dimH {(α, β) : ℝ × ℝ | Filter.atTop.liminf
      (fun n : ℕ ↦ n * distToNearestInt (n * α) * distToNearestInt (n * β)) > 0} = 0 := by
  sorry

end LeanEval.Dynamics.EinsiedlerKatokLindenstrauss
