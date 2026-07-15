# `semilinear_poisson_radial_symmetry`

Radial symmetry for positive semilinear Poisson solutions

- Problem ID: `semilinear_poisson_radial_symmetry`
- Test Problem: no
- Submitter: Yongxi Lin
- Source: B. Gidas, W. M. Ni, and L. Nirenberg, Symmetry and related properties via the maximum principle, Comm. Math. Phys. 68 (1979), 209-243. Also stated as Theorem 2 (Radial symmetry) in L. C. Evans, Partial Differential Equations, Section 9 on nonvariational techniques.
- Informal solution: Use the method of moving planes. Compare u with its reflection across a moving hyperplane.

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
