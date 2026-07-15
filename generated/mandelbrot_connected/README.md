# `mandelbrot_connected`

Mandelbrot set is connected (Douady–Hubbard)

- Problem ID: `mandelbrot_connected`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The Mandelbrot set for the quadratic family T_c(z) = z² + c is the parameter set for which the critical orbit of 0 is bounded. This problem states Douady–Hubbard's connectedness theorem. §62 of Knill's 'Some Fundamental Theorems in Mathematics'.
- Source: A. Douady and J. H. Hubbard, *Étude dynamique des polynômes complexes I, II*, Publ. Math. Orsay 84-02, 85-04. Listed as §62 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Use the Douady–Hubbard uniformisation: the Böttcher coordinate at infinity gives a conformal isomorphism from ℂ \ M to the exterior of the closed unit disk. Equivalently, after adjoining ∞, the complement of M in the Riemann sphere is simply connected, hence M is connected.

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
