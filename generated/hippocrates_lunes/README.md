# `hippocrates_lunes`

Hippocrates' theorem on lunes

- Problem ID: `hippocrates_lunes`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: For a right triangle, the sum of the areas of the two Hippocrates lunes equals the area of the triangle. Trusted helpers (det2, closedHalfDisk, hypotenuseSemidisk, horizontalLune, verticalLune, rightTriangle, …) are non-holes; the Euclidean squared distance is used explicitly to avoid the ℝ×ℝ sup metric. Mathlib has no lune-area result. Candidate from §166 of the Knill survey.
- Source: Hippocrates of Chios (c. 440 BC). Knill, §166.

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
