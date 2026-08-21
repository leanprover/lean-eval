# `ore_conjecture`

The Ore conjecture: every element of a finite nonabelian simple group is a commutator

- Problem ID: `ore_conjecture`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Adam Topaz
- Notes: This is Theorem 1 of the cited paper.
- Source: Martin W. Liebeck, E. A. O'Brien, Aner Shalev, and Pham Huu Tiep, *The Ore conjecture*, Journal of the European Mathematical Society 12 (2010), no. 4, 939–1008, Theorem 1, https://doi.org/10.4171/JEMS/220; https://ems.press/journals/jems/articles/3979.
- Informal solution: See the cited paper for the proof.

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
