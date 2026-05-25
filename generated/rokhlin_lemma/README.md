# `rokhlin_lemma`

Rokhlin lemma

- Problem ID: `rokhlin_lemma`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §109 of Knill's 'Some Fundamental Theorems in Mathematics'. Every aperiodic measure-preserving automorphism of a standard Borel probability space admits, for every height n and every ε > 0, a measurable tower base B such that B, T B, …, T^{n-1} B are pairwise disjoint with total measure ≥ 1 - ε. The [StandardBorelSpace Ω] hypothesis is essential: the countable-cocountable σ-algebra on ℝ with the integer-shift map x ↦ x + 1 is aperiodic and measure-preserving but admits no nontrivial Rokhlin towers (every cocountable base intersects its own shift; every countable base has zero-measure tower). Mathlib has MeasurePreserving, IsProbabilityMeasure, Function.periodicPts, Set.PairwiseDisjoint, and StandardBorelSpace, but no Rokhlin lemma. The Challenge ships four small helper defs (IsAperiodic, towerFloor, towerUnion, IsRokhlinTower).
- Source: V. A. Rokhlin, *A general measure-preserving transformation is not mixing*, Doklady Akademii Nauk SSSR 60 (1948), 349-351 (original Russian; English translation later); S. Kakutani, *Induced measure-preserving transformations*, Proc. Imp. Acad. Tokyo 19 (1943), 635-641 (independent discovery). Listed as §109 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). No formalization found in any major prover.
- Informal solution: Standard proof: pick a measurable set A of small measure ε/n with positive density relative to T's orbit structure (the Halmos–Kakutani skyscraper). The first-return time r : A → ℕ is a.e. finite by aperiodicity; partition A by level sets {r = k}. Reassemble disjoint level-k floors T^j ({r = k}) for j < k into a height-n tower by horizontal cuts; the remaining 'roof' has measure at most ε.

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
