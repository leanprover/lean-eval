# `boone_higman_simple`

Kuznetsov's theorem: finitely presented simple groups have solvable word problem

- Problem ID: `boone_higman_simple`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A finitely presented *simple* group has a decidable word problem. The word problem of a finite presentation φ : FreeGroup (Fin n) →* G is encoded as the predicate `w ↦ φ (FreeGroup.mk w) = 1' on `List (Fin n × Bool)' (signed-letter words); solvability is `ComputablePred' of that predicate — genuine algorithmic decidability via a Turing machine, not a bundled Prop. The hypotheses `hsurj` + `hker` unpack `Group.IsFinitelyPresented G` for this presentation. Solvability of the word problem is independent of the chosen finite presentation, so quantifying over an arbitrary one is the standard reading. §122 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: A.V. Kuznetsov, 'Algorithms as operations in algebraic systems', Uspekhi Mat. Nauk 13 (1958) 240–241 (Russian); W.W. Boone and G. Higman, 'An algebraic characterization of groups with soluble word problem', J. Austral. Math. Soc. 18 (1974) 41–53. §122 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Kuznetsov's argument is r.e.-from-both-sides. (1) The set of words `w' with `φ(w) = 1' is recursively enumerable: enumerate the relators and all of their formal consequences (conjugates, products, and inverses). (2) For a nontrivial simple group G, the *negation* `φ(w) ≠ 1' is also r.e.: if `w' is nontrivial in G, the normal closure of `w' is all of G, so adding `w = 1' as a relator collapses the presented group to the trivial group. Concretely, semi-decide `w ≠ 1' by enumerating consequences of `rels ∪ {w}' until each generator g_i is forced to equal 1; once that finite generator-collapse certificate appears, `w ≠ 1' is confirmed. (3) Both r.e. ⇒ decidable (the standard `r.e. ∧ co-r.e. ⇒ decidable' theorem). The lean-eval `IsSimpleGroup' typeclass extends `Nontrivial', so the trivial-group degeneracy is excluded automatically. Mathlib has `Group.IsFinitelyPresented', `Subgroup.IsNormalClosureFG', `FreeGroup', `PresentedGroup', `IsSimpleGroup', and the `ComputablePred` / `Computable` / `Partrec` stack, but no notion of a word problem, no Kuznetsov / Novikov result, and no r.e./co-r.e. machinery wired to group presentations.

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
