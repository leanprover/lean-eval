# `variable_binder_example`

variable-binder minimal example

- Problem ID: `variable_binder_example`
- Test Problem: yes
- Submitter: Kim Morrison
- Notes: Regression for https://github.com/leanprover/lean-eval/issues/276. The theorem inherits implicit binders from a preceding `variable` declaration, which the extractor must re-emit in the generated workspace.

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
