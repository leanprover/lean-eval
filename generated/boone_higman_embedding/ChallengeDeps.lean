import Mathlib

namespace LeanEval.GroupTheory.BooneHigmanEmbedding

/-!
# Boone–Higman theorem (easy direction)

`boone_higman_embedding`: if a finitely presented group `G` embeds in a simple
group `H` that embeds in a finitely presented group `K`, then `G` has a solvable
word problem — the "if" half of the Boone–Higman characterisation. The trusted
helper `WordProblemSolvable` (a non-hole) expresses decidability of "a word
represents the identity" via `ComputablePred`. Mathlib has finitely-presented
groups, free groups, simple groups, and computability, but no notion of the word
problem or the Boone–Higman theorem. (The main Kuznetsov/Boone–Higman, Novikov,
and Higman-infinite-simple statements of §122 are already in lean-eval.)

Category-(b) candidate from §122 of the Knill survey (additional statement 1).
-/

/-- The **word problem is solvable** for a finite presentation
`φ : FreeGroup (Fin n) →* G`: the predicate "the word `w` represents the identity
of `G`" is decidable by an algorithm. -/
def WordProblemSolvable {G : Type*} [Group G] {n : ℕ}
    (φ : FreeGroup (Fin n) →* G) : Prop :=
  ComputablePred (fun w : List (Fin n × Bool) => φ (FreeGroup.mk w) = 1)



end LeanEval.GroupTheory.BooneHigmanEmbedding
