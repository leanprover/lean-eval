# `mergelyan_theorem`

Mergelyan's theorem

- Problem ID: `mergelyan_theorem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Mergelyan's theorem: if K ⊆ ℂ is compact with connected complement, then every function continuous on K and holomorphic on interior K is uniformly approximable on K by complex polynomials. §64 of Knill's 'Some Fundamental Theorems in Mathematics'.
- Source: S. N. Mergelyan, *On the representation of functions by series of polynomials on closed sets*, Doklady Akad. Nauk SSSR 78 (1951), 405-408 (Russian). Listed as §64 (additional statement 4) in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: A standard proof approximates f uniformly on K by an entire function, using Cauchy–Green / Pompeiu or related ∂̄ methods, and then approximates the entire function uniformly on the compact set K by Taylor polynomials.

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
