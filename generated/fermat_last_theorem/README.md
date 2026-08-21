# `fermat_last_theorem`

Fermat's Last Theorem

- Problem ID: `fermat_last_theorem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Xuanji Li
- Notes: Fermat's Last Theorem: a^n + b^n = c^n has no nontrivial natural solution when n >= 3.
- Source: https://en.wikipedia.org/wiki/Fermat%27s_Last_Theorem
- Informal solution: via https://en.wikipedia.org/wiki/Modularity_theorem

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
