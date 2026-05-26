import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# Feit–Thompson odd-order theorem

Every finite group of odd order is solvable. Proved by Walter Feit and John
G. Thompson in 1963 (Pacific J. Math. 13) — a 255-page paper that opened
the path to the Classification of Finite Simple Groups; Thompson received
the Fields Medal in 1970 in part for this work. A landmark formalization
in Coq was completed by Georges Gonthier's team in 2012 (170 000 lines).
There is no Lean port.

The statement requires **zero new definitions** — mathlib already has
`IsSolvable`, `Odd`, `Nat.card`, and the `Group` / `Finite` typeclasses.
The challenge is the proof, which combines character theory, generic-case
analysis, the CN-group structure theorem, and the analysis of so-called
"thinly embedded" maximal subgroups via the Frobenius–Wielandt machinery.

Feit-Thompson is one of two named honorable mentions on Freek Wiedijk's
*Formalizing 100 Theorems* page (alongside the Classification of Finite
Simple Groups itself).
-/

/-- **Feit–Thompson odd-order theorem.** Every finite group of odd order is
solvable. -/
@[eval_problem]
theorem feit_thompson {G : Type*} [Group G] [Finite G]
    (_h : Odd (Nat.card G)) : IsSolvable G := by
  sorry

end GroupTheory
end LeanEval
