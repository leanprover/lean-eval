# `multi_hole_helpers_example`

multi-hole-with-helpers regression example

- Problem ID: `multi_hole_helpers_example`
- Test Problem: yes
- Submitter: Kim Morrison
- Holes (3): `Helpers.first` (def), `Helpers.second_eq` (theorem), `Helpers.third_eq` (theorem)
- Notes: Regression test for trusted-helper support in multi-hole problems. Exercises three failure modes the generator used to have: (1) helpers at root namespace (`rootHelper`) must not get a spurious `open`; (2) the helper namespace `Helpers` differs from the module's last path component `MultiHoleHelpersExample`, so the injected `open` must be derived from the helper names rather than the module name; (3) the helper `Helpers.postHole` appears in source order *between* two holes, exercising the right-to-left edit pass against a layout where a sequential strip-then-replace pipeline (with helper ranges taken from `.ilean` and applied after hole-body replacement) would have shifted offsets. A submission that defines `Submission.Helpers.first := 1`, `Submission.Helpers.second_eq := rfl`, and `Submission.Helpers.third_eq := rfl` should be accepted.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
