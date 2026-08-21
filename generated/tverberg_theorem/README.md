# `tverberg_theorem`

Tverberg's theorem

- Problem ID: `tverberg_theorem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Any (r-1)(d+1)+1 points in ℝ^d can be partitioned into r parts whose convex hulls share a common point. Trusted helper HasTverbergPartition (non-hole). Mathlib has Radon's theorem (the r=2 case) but not Tverberg. Candidate from §169 of the Knill survey.
- Source: H. Tverberg, *A generalization of Radon's theorem*, J. London Math. Soc. 41 (1966). Knill, §169.

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
