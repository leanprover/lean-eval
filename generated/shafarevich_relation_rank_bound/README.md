# `shafarevich_relation_rank_bound`

Shafarevich's relation-rank bound

- Problem ID: `shafarevich_relation_rank_bound`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a number field F and odd prime p, with G = Gal(F^{un,p}/F) the Galois group of the maximal unramified pro-p extension, the relation rank r(G) = dim_{𝔽_p} H²(G; 𝔽_p) is finite and r(G) ≤ d(G) + (r₁ + r₂ - 1) + δ_p(F), where d(G) is the generator rank, r₁/r₂ are the numbers of real/complex places of F, and δ_p(F) = 1 iff F contains a primitive p-th root of unity. The statement rests on substantial trusted scaffolding (non-holes): the bespoke construction MaxUnramifiedProPGaloisGroup (with IsEverywhereUnramified and maximalUnramifiedProPF) fixing Gal(F^{un,p}/F), and the rank definitions generatorRank, relationRank, H2Finite — a solver proves the inequality about these definitions, whose correctness is part of the trusted statement. This is one of the two external inputs taken as a hypothesis in Logical Intelligence's formalization of the disproof of Erdős's unit-distance conjecture (Hyp_ShafarevichRelationRankBound). It was reviewed for faithfulness against Mayer Theorem 5.1 (S=∅) and Koch 11.5/11.8; the unit-rank term r₁+r₂-1 and the root-of-unity correction match Mayer's corrected statement, and the MaxUnramifiedProPGaloisGroup construction was checked as a faithful (non-vacuous) maximal unramified pro-p extension in the source development (whose universal-property/maximality lemmas are not shipped with this problem — only the definitions are).
- Source: D. C. Mayer, *New number fields with known p-class tower*, Tatra Mt. Math. Publ. 64 (2015), 21–57 (Theorem 5.1, S=∅; arXiv:1510.00565); H. Koch, *Galois Theory of p-Extensions*, Springer 2002 (Theorems 11.5 and 11.8); I. R. Shafarevich, *Extensions with prescribed ramification points* (1963). Lean hypothesis: https://github.com/logical-intelligence/erdos-unit-distance (Hyp_ShafarevichRelationRankBound).
- Informal solution: Compute the cohomology of the pro-p group G = Gal(F^{un,p}/F) via class field theory. The generator rank d(G) = dim H¹(G; 𝔽_p) is the p-rank of the ray/Hilbert class field data, and the relation rank r(G) = dim H²(G; 𝔽_p) is bounded using the global Euler-characteristic / Poitou–Tate duality for the maximal unramified pro-p extension: the difference r(G) - d(G) is controlled by the unit group and the p-th roots of unity, giving r(G) - d(G) ≤ (r₁ + r₂ - 1) + δ_p(F) (the Dirichlet unit rank plus the δ-term recording whether ζ_p ∈ F). Faithful to Mayer's Theorem 5.1 with empty ramification set S.

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
