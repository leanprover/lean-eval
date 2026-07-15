# `fang_xia_tiling_partition_transitive`

Fang–Xia: tiling of the symmetric group by transpositions implies λ-transitivity

- Problem ID: `fang_xia_tiling_partition_transitive`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: If T_n = {1} ∪ {all transpositions} and (T_n, Y) tiles the symmetric group S_n (every element of S_n has a unique factorisation x · y with x ∈ T_n, y ∈ Y), then for every integer partition λ of n whose Young-diagram content sum is nonnegative, Y is λ-transitive in the Martin–Sagan sense: there is a fixed positive integer r such that, for every pair P, Q of ordered set partitions of shape λ, exactly r elements of Y send P to Q blockwise. Content sum is encoded in the row-length formula `∑ᵢ aᵢ · (aᵢ − 2i − 1)` (zero-indexed rows), matching the paper's one-indexed `λᵢ · (λᵢ − 2i + 1)`. Headline Theorem 1.4 of Fang–Xia, *Tiling the symmetric group by transpositions*, Bull. London Math. Soc. 58(5) (2026).
- Source: T. Fang and B. Xia, 'Tiling the symmetric group by transpositions', Bull. London Math. Soc. 58(5) (2026); DOI 10.1112/blms.70366; arXiv:2506.00360. The λ-transitivity notion in the statement is due to Martin–Sagan.
- Informal solution: The paper proves Theorem 1.4 by symmetric-group character theory. In the group algebra of S_n, the tiling condition gives the convolution identity `1_{T_n} * 1_Y = 1_{S_n}`. Since T_n is conjugation-invariant, convolution by `1_{T_n}` acts on each Specht module by a scalar expressible in terms of the content sum of λ. For partitions with nonnegative content sum that scalar is nonzero, so the corresponding Specht component survives in 1_Y, which implies the Martin–Sagan constant-count transitivity condition for Y on ordered set partitions of shape λ. Mathlib has `Equiv.Perm (Fin n)`, `Equiv.swap`, `Finset`, `YoungDiagram`, `Combinatorics.Tiling.Tile`, `SimpleGraph.Cayley`, and `RepresentationTheory.Character`, but no Specht-module / symmetric-group central-character content-sum theorem and no partition-transitivity API.

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
