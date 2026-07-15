# `runge_theorem`

Runge's theorem

- Problem ID: `runge_theorem`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Basic Runge approximation theorem for compact subsets of ℂ. The statement uses polynomials p q : ℂ[X] and requires q to be nonvanishing on K, expressing rational functions with no poles on K. This does not include the standard pole-control refinement (one pole per connected component of ℂ \ K).
- Source: C. Runge, *Zur Theorie der eindeutigen analytischen Funktionen*, Acta Math. 6 (1885), 229-244. Listed as §64 (additional statement 3) in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Show that rational functions with poles outside K are dense in the algebra of functions holomorphic on a neighbourhood of K, with respect to the uniform norm on K. Classical proofs go via Cauchy integral approximation or via Hahn–Banach / Riesz duality.

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
