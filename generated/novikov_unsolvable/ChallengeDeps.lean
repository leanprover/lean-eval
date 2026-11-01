import Mathlib

namespace LeanEval
namespace GroupTheory
namespace NovikovUnsolvableProblem

/-!
# Novikov's theorem: undecidability of the word problem

There exists a finitely presented group whose word problem is
undecidable. P.S. Novikov 1955 / W.W. Boone 1958. §122 in Knill's
*Some Fundamental Theorems in Mathematics*.

The standard encoding: a word in the generators `g₁, …, gₙ` and their
inverses is `List (Fin n × Bool)`, which is `Primcodable`. The word
problem of a finite presentation `φ : FreeGroup (Fin n) →* G` is the
predicate "`w` represents the identity of `G`", and solvability is
`ComputablePred` of that predicate. Novikov's theorem asserts the
existence of `n` and a finite relator set `rels ⊆ FreeGroup (Fin n)`
for which the canonical surjection
`PresentedGroup.mk rels : FreeGroup (Fin n) →* PresentedGroup rels`
has *no* such algorithm.
-/

/-- The word problem of a finite presentation `φ` is **solvable** when
the predicate "the word `w` represents the identity of `G`" is
decidable by an algorithm. -/
def WordProblemSolvable {G : Type*} [Group G] {n : ℕ}
    (φ : FreeGroup (Fin n) →* G) : Prop :=
  ComputablePred (fun w : List (Fin n × Bool) => φ (FreeGroup.mk w) = 1)



end NovikovUnsolvableProblem
end GroupTheory
end LeanEval
