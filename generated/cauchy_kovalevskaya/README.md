# `cauchy_kovalevskaya`

Cauchy–Kovalevskaya theorem

- Problem ID: `cauchy_kovalevskaya`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: §32 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. The quasi-linear scalar Cauchy problem with real-analytic data has a unique local analytic solution. Stated with off-the-shelf mathlib (AnalyticOnNhd, fderiv, EuclideanSpace); the PDE is encoded through the Fréchet derivative, with fderiv u p (0,1) the time derivative and fderiv u p (v,0) the spatial directional derivative. Mathlib has no Cauchy-Kovalevskaya theorem, and no formalization of it was found in any other proof assistant.
- Source: A.-L. Cauchy (1842) and S. Kovalevskaya (1875). Listed as §32 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Construct the solution as a formal power series in (x, t) whose coefficients are determined recursively by differentiating the PDE and using the initial data; prove convergence by the method of majorants — bound the analytic data F, f, u₀ by geometric majorants for which the majorant Cauchy problem has an explicitly convergent closed-form solution, so the formal series converges on a neighborhood and is analytic there. Uniqueness holds because the power-series coefficients of any analytic solution with the given initial data are forced by the equation.

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
