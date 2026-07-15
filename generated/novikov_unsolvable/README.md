# `novikov_unsolvable`

Novikov's theorem: the word problem is undecidable for finitely presented groups

- Problem ID: `novikov_unsolvable`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: There exists a finitely presented group with undecidable word problem. Concretely: some n and a finite relator set rels ⊆ FreeGroup (Fin n) for which the canonical surjection `PresentedGroup.mk rels` admits no `ComputablePred` decision procedure for `w ↦ φ (FreeGroup.mk w) = 1`. Pure existence of a pathological finite presentation; the negation (every finite presentation has solvable word problem) was disproved by Novikov 1955 and independently by Boone 1958. §122 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: P.S. Novikov, 'On the algorithmic unsolvability of the word problem in group theory', Trudy Mat. Inst. Steklov. 44 (1955) 1–143 (Russian); W.W. Boone, 'The word problem', Ann. of Math. (2) 70 (1959) 207–265 (announced 1958). §122 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Novikov and Boone construct a finite presentation of a group whose word problem encodes the halting problem of a universal Turing machine. (1) Encode a Turing machine M whose halting problem is undecidable as a finitely presented **semigroup**: a fixed list of rewriting rules whose word problem mirrors halting. (2) Lift the semigroup presentation to a finitely presented **group** by Boone's machinery using HNN extensions and Britton's lemma, preserving the equivalence: the question 'does M halt on input x' becomes 'does the word w_x equal 1 in the constructed group G'. (3) Since the halting problem is undecidable, so is the word problem of G; G is finitely presented by construction. Mathlib v4.30 has `FreeGroup`, `PresentedGroup`, `Group.IsFinitelyPresented`, HNN extensions (`Mathlib/GroupTheory/HNNExtension.lean`, including Britton's lemma as `HNNExtension.ReducedWord.toList_eq_nil_of_mem_of_range`), and the full `ComputablePred` / `Computable` / `Partrec` / `Nat.Partrec.Code` stack, but no Turing-machine-to-finitely-presented-group simulation and no Novikov / Boone unsolvability result.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
