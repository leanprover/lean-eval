# `heat_kernel_solves_heat_equation`

Gaussian heat kernel solves the 1D heat equation

- Problem ID: `heat_kernel_solves_heat_equation`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: The Gaussian convolution u(t,x) = (4 pi t)^{-1/2} integral exp(-(x-y)^2/(4t)) f(y) dy satisfies the heat equation on (0, infty) x R, with initial datum f recovered as t -> 0+.
- Source: Classical heat-equation theory.
- Informal solution: Differentiate under the integral sign in t and twice in x; the kernel itself satisfies the heat equation, so does its convolution with f. As t -> 0+, the Gaussian is an approximate identity with total mass 1. After the change of variables y = x + sqrt(t) z, the integral becomes an average of f(x + sqrt(t) z) against a fixed integrable Gaussian weight; continuity of f at x and boundedness of f then give pointwise convergence to f(x) by dominated convergence in z.

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
