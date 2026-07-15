# `alternating_sign_matrix_count`

The alternating sign matrix theorem

- Problem ID: `alternating_sign_matrix_count`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The number of n×n alternating sign matrices is the Robbins product ∏_{k<n} (3k+1)!/(n+k)! (Zeilberger 1994; Kuperberg 1996). Trusted helpers (IsAlternatingSignMatrix, ASMatrix, robbinsProduct, …) are non-holes. Mathlib has no ASM enumeration. Candidate from §168 of the Knill survey.
- Source: D. Zeilberger (1996); G. Kuperberg (1996). Knill, §168.

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
