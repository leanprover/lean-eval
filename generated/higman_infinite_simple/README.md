# `higman_infinite_simple`

Higman's infinite finitely-presented simple group

- Problem ID: `higman_infinite_simple`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: There exists an infinite, finitely presented, simple group: some n and a finite relator set rels ⊆ FreeGroup (Fin n) for which PresentedGroup rels is both simple and infinite. Pure existence of a pathological finite presentation. The first such examples come from Higman's 1974 monograph (the Higman–Thompson groups G_{n,r}); Higman's 1951 paper only constructs a finitely *generated* infinite simple group (a simple quotient of the four-generator group with no nontrivial finite quotients), not a finitely presented one. Mathlib v4.30 has FreeGroup, PresentedGroup, IsSimpleGroup, Infinite, HNN extensions (`Mathlib/GroupTheory/HNNExtension.lean`), and Britton's lemma, but no Higman–Thompson construction, no Higman embedding theorem, and no construction of an infinite finitely-presented simple group. §122 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: G. Higman, 'A finitely generated infinite simple group', J. London Math. Soc. 26 (1951) 61–64; G. Higman, *Finitely Presented Infinite Simple Groups*, Notes on Pure Mathematics 8, Australian National University, 1974. §122 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Higman's 1974 monograph constructs the Higman–Thompson groups G_{n,r} (for integers n ≥ 2, r ≥ 1) as groups of piecewise-linear bijections of certain Cantor-like spaces / r-tuples of n-ary trees. Each G_{n,r} is finitely presented (explicit finite generators and relations are written down) and infinite by construction; the commutator subgroups G_{n,r}' (or G_{n,r} itself for suitable n, r) are simple, by an analysis of the action on the underlying space. Higman's 1951 paper had earlier exhibited a finitely *generated* infinite simple group — a simple quotient of the four-generator group `⟨a, b, c, d | bab⁻¹ = a², cbc⁻¹ = b², dcd⁻¹ = c², ada⁻¹ = d²⟩` with no nontrivial finite quotients — but did not give a finite presentation of the simple quotient. Mathlib v4.30 has the substrate (`FreeGroup`, `PresentedGroup`, `IsSimpleGroup`, `Infinite`, `Subgroup.IsNormalClosureFG`), HNN extensions and Britton's lemma (`Mathlib/GroupTheory/HNNExtension.lean`), but no Higman–Thompson groups, no Higman embedding theorem, and no construction of an infinite finitely-presented simple group.

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
