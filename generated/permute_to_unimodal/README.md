# `permute_to_unimodal`

A competition programming problem about permuting a permutation to be unimodal

- Problem ID: `permute_to_unimodal`
- Test Problem: no
- Submitter: Julia M. Himmel
- Source: NWERC 2025 Problem G, see https://2025.nwerc.eu/problem-set.pdf
- Informal solution: See https://2025.nwerc.eu/solutions.pdf for a sketch of the correctness, which goes in two steps: construct a quadratic-time dynamic programming solution, then efficiently evaluate that in O(n log n). The hard part is showing the correspondence between LISs of prefixes of the constructed sequence and values of the DP.

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
