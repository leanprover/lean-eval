# `morley_theorem`

Morley's trisector theorem

- Problem ID: `morley_theorem`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The triangle formed by the adjacent angle-trisectors of any nondegenerate Euclidean triangle is equilateral. Trusted helpers (IsEquilateralTriple, LiesInTriangle, IsMorleyConfiguration) are non-holes. Mathlib has Euclidean angles but not Morley's theorem. Candidate from §162 of the Knill survey.
- Source: F. Morley (c. 1899). Knill, §162.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
