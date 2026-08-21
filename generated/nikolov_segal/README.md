# `nikolov_segal`

Nikolov–Segal strong completeness theorem

- Problem ID: `nikolov_segal`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Adam Topaz
- Notes: Every finite-index subgroup of a topologically finitely generated profinite group is open.
- Source: Nikolay Nikolov and Dan Segal, *On finitely generated profinite groups, I: strong completeness and uniform bounds*, Annals of Mathematics 165 (2007), no. 1, 171–238, Theorem 1.1, https://doi.org/10.4007/annals.2007.165.171; *On finitely generated profinite groups, II: products in quasisimple groups*, Annals of Mathematics 165 (2007), no. 1, 239–273, https://doi.org/10.4007/annals.2007.165.239.
- Informal solution: See Nikolov and Segal, Parts I and II, cited in `source`.

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
