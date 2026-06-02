import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory
namespace HigmanInfiniteSimpleProblem

/-!
# Higman's infinite finitely-presented simple group

There exists an infinite, finitely presented, simple group. Graham
Higman gave the first example in 1951; a much shorter construction
appears in Higman's 1974 monograph *Finitely Presented Infinite Simple
Groups*. §122 in Knill's *Some Fundamental Theorems in Mathematics*.

Concretely: some `n` and a finite relator set
`rels ⊆ FreeGroup (Fin n)` for which `PresentedGroup rels` is both
simple and infinite. Pure existence of a pathological finite
presentation. Mathlib has `FreeGroup`, `PresentedGroup`,
`IsSimpleGroup`, and `Infinite`, but no construction of any infinite
finitely-presented simple group.
-/

/-- **Higman's infinite simple group** (G. Higman 1951/1974). There
exists an infinite finitely presented simple group. -/
@[eval_problem]
theorem higman_infinite_simple :
    ∃ (n : ℕ) (rels : Set (FreeGroup (Fin n))),
      rels.Finite ∧ IsSimpleGroup (PresentedGroup rels) ∧
        Infinite (PresentedGroup rels) := by
  sorry

end HigmanInfiniteSimpleProblem
end GroupTheory
end LeanEval
