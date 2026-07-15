import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory
namespace HigmanInfiniteSimpleProblem

/-!
# Higman's infinite finitely-presented simple group

There exists an infinite, finitely presented, simple group. The first
such examples come from Graham Higman's 1974 monograph *Finitely
Presented Infinite Simple Groups* — the Higman–Thompson groups
`G_{n, r}`. (Higman's 1951 paper had earlier exhibited a finitely
*generated* infinite simple group — a simple quotient of the
four-generator group with no nontrivial finite quotients — but did
not give a finite presentation for the simple quotient.) §122 in
Knill's *Some Fundamental Theorems in Mathematics*.

Concretely: some `n` and a finite relator set
`rels ⊆ FreeGroup (Fin n)` for which `PresentedGroup rels` is both
simple and infinite. Pure existence of a pathological finite
presentation. Mathlib v4.30 has `FreeGroup`, `PresentedGroup`,
`IsSimpleGroup`, `Infinite`, HNN extensions, and Britton's lemma, but
no Higman–Thompson construction and no infinite finitely-presented
simple group on hand.
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
