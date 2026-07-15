# `pell_solution_convergent`

Pell solutions are convergents of √d

- Problem ID: `pell_solution_convergent`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §84 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. Lagrange's theorem: if d is a positive squarefree integer and (x, y) is a positive solution of Pell's equation x² − d y² = 1, then x/y occurs as a convergent of the regular continued fraction of √d, connecting the arithmetic of Pell solutions with the continued-fraction expansion of a quadratic irrational. Mathlib has APIs for Pell solutions (Pell.Solution₁) and for continued fractions (GenContFract.of, GenContFract.convs) but currently lacks any theorem relating positive Pell solutions to convergents of √d.
- Source: J.-L. Lagrange (1770). Listed as §84 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Expand √d as a regular continued fraction; for squarefree d ≥ 2 this is infinite with convergents pₙ/qₙ satisfying |pₙ² − d qₙ²| < 1 + 2√d, so the values pₙ² − d qₙ² are bounded and some value v is attained infinitely often. A positive Pell solution (x, y) with x² − d y² = 1 is a best rational approximation of √d from the relevant side: |x/y − √d| < 1/(2y²), and by Legendre's theorem (mathlib's Real.exists_convs_eq_rat-style best-approximation criterion) any rational p/q in lowest terms with |p/q − √d| < 1/(2q²) is a convergent of √d. Since x² − d y² = 1 gives gcd x y = 1 and the required approximation bound, x/y = convs n for some n.

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
