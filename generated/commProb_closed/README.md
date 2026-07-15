# `commProb_closed`

Commuting probabilities are closed

- Problem ID: `commProb_closed`
- Test Problem: no
- Submitter: Thomas Browning
- Notes: The set of commuting probabilities of finite groups is closed.
- Source: https://arxiv.org/abs/2201.09402
- Informal solution: Neumann's theorem describes the structure of finite groups with bounded below commuting probability. Then pass to subsequences of groups with similar structure.

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
