# `riesz_brothers_theorem`

Riesz brothers' theorem

- Problem ID: `riesz_brothers_theorem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Yongxi Lin
- Source: W. Rudin, Real and Complex Analysis; N. K. Nikolski, Operators, Functions, and Systems: An Easy Reading, Volume I: Hardy, Hankel, and Toeplitz.
- Informal solution: One proof, given in Rudin's Real and Complex Analysis, uses the uniqueness of the Poisson integral representation. Another proof presented in Nikolski's book relies on Wold's decomposition.

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
