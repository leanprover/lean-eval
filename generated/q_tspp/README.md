# `q_tspp`

The q-TSPP theorem

- Problem ID: `q_tspp`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Timothy Y. Chow
- Notes: The orbit-counting formula for totally symmetric plane partitions,
stated as an identity of integer polynomials after clearing denominators.
Coordinates start at zero, and orbits are counted by their unique
representatives with weakly increasing coordinates.

- Source: Koutschan, Kauers, and Zeilberger (2011), Theorem 1. DOI: 10.1073/pnas.1019186108

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
