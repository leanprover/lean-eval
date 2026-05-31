# `conway_schneeberger_fifteen`

Conway–Schneeberger fifteen theorem

- Problem ID: `conway_schneeberger_fifteen`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A positive-definite integer-matrix quadratic form Q : ℤⁿ → ℤ is universal (represents every positive integer) iff it represents every integer in {1, 2, …, 15}. The matrix-explicit formulation records the classically integral hypothesis: the form is given by an integral symmetric matrix, so off-diagonal polynomial coefficients are even — distinguishing this 15 theorem from Bhargava–Hanke's 290 theorem (integer-valued forms, off-diagonal half-integers allowed). §95 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: Conway–Schneeberger 1993 (unpublished, communicated by Conway in lectures); full proof M. Bhargava, 'On the Conway–Schneeberger fifteen theorem', in *Quadratic Forms and their Applications* (Contemp. Math. 272, AMS 2000). Listed as §95 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Bhargava's proof reduces universality to representation of a 9-element critical set {1, 2, 3, 5, 6, 7, 10, 14, 15} via the *escalator-tree* argument: any non-universal positive-definite integer-matrix form has a smallest non-represented integer m, and the escalator extensions by adding diagonal m form a finite tree whose leaves can be enumerated. Exhaustive case analysis on the tree shows that any non-universal form must fail to represent at least one of the nine critical integers. Mathlib has `Nat.sum_four_squares` (Lagrange) but no universal-quadratic-form framework: no `IsUniversal` predicate, no escalator construction, no integer-matrix-versus-integer-valued distinction. The 15 in the statement is sharp: the form (1, 2, 5, 5) represents {1, …, 14} but not 15.

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
