# `shafarevich_solvable_galois`

Shafarevich's theorem on solvable Galois groups

- Problem ID: `shafarevich_solvable_galois`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Ryan Smith
- Notes: Every finite solvable group is realizable as a Galois group over ℚ: the solvable case of the inverse Galois problem. Mathlib has IsSolvable and the Galois correspondence, but nothing about realizability — no embedding problems, no Scholz–Reichardt construction, no inverse-Galois API at all — so a solver builds the extensions from scratch. Distinct from the two other Shafarevich problems in the catalog: shafarevich_relation_rank_bound (the cohomological relation-rank inequality for the maximal unramified pro-p extension) and golod_shafarevich_inequality. Shafarevich's original 1954 proof contained an error at the prime 2, which he later corrected; the source field cites both the correction and a modern complete proof.
- Source: I. R. Shafarevich, 'Construction of fields of algebraic numbers with given solvable Galois group', Izv. Akad. Nauk SSSR Ser. Mat. 18 (1954), no. 6, 525–578, https://www.mathnet.ru/eng/im3517. The prime-2 correction appears in Shafarevich's Collected Mathematical Papers, Springer (1989). For a complete corrected proof, see A. Schmidt and K. Wingberg, 'Šafarevič's theorem on solvable groups as Galois groups' (1998), https://arxiv.org/abs/math/9809211.
- Informal solution: Reduce the realization problem to split finite embedding problems with nilpotent kernels. For each p-primary kernel, construct controlled Scholz solutions and solve successive central embedding problems. When an obstruction appears, Shafarevich's shrinking procedure modifies earlier stages so that the obstruction vanishes; the corrected argument handles the prime 2. Iterating along a solvable series yields a finite Galois extension K/ℚ with Galois group G.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
