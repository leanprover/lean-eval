import Mathlib

namespace LeanEval
namespace GroupTheory
namespace BooneHigmanSimpleProblem

/-!
# Kuznetsov / Boone–Higman: simple finitely presented groups have
solvable word problem

A finitely presented *simple* group has a decidable word problem.
This is Kuznetsov's theorem (A.V. Kuznetsov, 1958); the later
Boone–Higman characterisation (W.W. Boone and G. Higman, 1974) gives
the full iff statement situating Kuznetsov's result. §122 in Knill's
*Some Fundamental Theorems in Mathematics*.

A word in the generators `g₁, …, gₙ` and their inverses is encoded as
`List (Fin n × Bool)`, which is `Primcodable`. The word problem of a
finite presentation `φ : FreeGroup (Fin n) →* G` is the predicate "the
word `w` represents the identity of `G`"; it is **solvable** when this
predicate is decidable by an algorithm, captured by mathlib's
`ComputablePred`. The hypotheses `hsurj` + `hker` unpack
`Group.IsFinitelyPresented G` for this particular presentation `φ`.

Mathlib has `Group.IsFinitelyPresented`, `Subgroup.IsNormalClosureFG`,
`FreeGroup`, `PresentedGroup`, `IsSimpleGroup`, and the
`ComputablePred` / `Computable` / `Partrec` stack, but no notion of
the word problem of a group or the Kuznetsov / Boone–Higman / Novikov
theorems.
-/

/-- The word problem of a finite presentation `φ` is **solvable** when
the predicate "the word `w` represents the identity of `G`" is
decidable by an algorithm. -/
def WordProblemSolvable {G : Type*} [Group G] {n : ℕ}
    (φ : FreeGroup (Fin n) →* G) : Prop :=
  ComputablePred (fun w : List (Fin n × Bool) => φ (FreeGroup.mk w) = 1)



end BooneHigmanSimpleProblem
end GroupTheory
end LeanEval
