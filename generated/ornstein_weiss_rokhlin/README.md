# `ornstein_weiss_rokhlin`

Ornstein–Weiss ℤᵈ Rokhlin lemma

- Problem ID: `ornstein_weiss_rokhlin`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §109 of Knill's 'Some Fundamental Theorems in Mathematics' (additional statement; the boxed main theorem is the classical Rokhlin lemma). The multidimensional generalization: for every free measure-preserving ℤᵈ-action T on a standard Borel probability space, every box size N ≥ 1, and every ε > 0, there is a measurable base B such that the translates T v '' B for v ∈ [0, N)ᵈ are pairwise disjoint with measure ≥ 1 - ε. Three hypotheses beyond the classical lemma: 1 ≤ d (rules out d = 0 degeneracy); the identity axiom T 0 = id (homomorphism alone only forces T 0 idempotent); [StandardBorelSpace Ω] (rules out the countable-cocountable σ-algebra defect). Mathlib has MeasurePreserving, IsProbabilityMeasure, Set.PairwiseDisjoint, Fintype.piFinset, Finset.Ico, StandardBorelSpace, but no Ornstein–Weiss lemma, no free measure-preserving ℤᵈ-actions, no multidimensional Rokhlin towers. The Challenge ships two small helper defs (IsFreeAction, boxShape).
- Source: D. S. Ornstein and B. Weiss, *Entropy and isomorphism theorems for actions of amenable groups*, J. Anal. Math. 48 (1987), 1-141 — Theorem 5.2 establishes the multidimensional (and amenable-group) Rokhlin lemma. Listed as §109 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). No formalization found in any major prover.
- Informal solution: Standard proof reduces to the one-dimensional Rokhlin lemma by induction on d using the quasi-tiling lemma of Ornstein–Weiss: every Følner set in ℤᵈ can be ε-quasi-tiled by finitely many translates of cubes [0, N)ᵈ, so a one-dimensional skyscraper over a transversal of one direction can be folded into a d-dimensional Rokhlin tower with arbitrarily small remainder.

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
