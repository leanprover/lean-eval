# `linnik`

Linnik's theorem (L = 5.5)

- Problem ID: `linnik`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Bolton Bailey/Project Numina
- Notes: Linnik's theorem with the explicit constant `L = 5.5` due to Heath-Brown (1992): for `a` coprime to `d` with `0 < a < d`, the least prime `p(a, d)` in the progression `a mod d` satisfies `p(a, d) ≤ c · d ^ 5.5` for some absolute constant `c`.
- Source: Heath-Brown, D.R. (1992), Zero-Free Regions for Dirichlet L-Functions, and the Least Prime in an Arithmetic Progression. Proceedings of the London Mathematical Society, s3-64: 265-338. https://doi.org/10.1112/plms/s3-64.2.265
- Informal solution: Heath-Brown's proof rests on three principles: a quantitative zero-free region for Dirichlet L-functions, the Deuring-Heilbronn phenomenon, and the log-free zero-density estimate. Heath-Brown combines strong versions of these estimates to obtain an exponent of 5.5.

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
