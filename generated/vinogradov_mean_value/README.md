# `vinogradov_mean_value`

Vinogradov mean value theorem

- Problem ID: `vinogradov_mean_value`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Junyan Xu
- Notes: The Bourgain–Demeter–Guth proof relies solely on harmonic analysis techniques rather than number theoretic methods all previous progress relied on, and allows integers to be replaced with arbitrary well separated real numbers. The theorem is derived as a consequence of a sharp decoupling inequality for curves. Wooley's proof uses his nested efficient congruencing method, which in contrast with the l2-decoupling method makes no use of multilinear Kakeya estimates, so is of sufficient flexibility to be applicable in algebraic number fields, and in function fields.

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
