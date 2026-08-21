# `finite_graph_ramsey_theorem`

Finite Ramsey theorem for graphs

- Problem ID: `finite_graph_ramsey_theorem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: States finite Ramsey existence for red/blue edge colourings of complete graphs, encoded by a graph and its complement.
- Source: Classical theorem in Ramsey theory.
- Informal solution: Show that for every r and s there is an n such that every graph on n vertices contains either a clique of size r or an independent set of size s.

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
