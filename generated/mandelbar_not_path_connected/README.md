# `mandelbar_not_path_connected`

Mandelbar (tricorn) is not path-connected (Hubbard–Schleicher)

- Problem ID: `mandelbar_not_path_connected`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The d = 2 case of Hubbard–Schleicher's theorem that multicorns — connectedness loci of unicritical antiholomorphic polynomials z ↦ z̄^d + c — are not path-connected for d ≥ 2. For d = 2 this is the mandelbar / tricorn, the connectedness locus of z ↦ z̄² + c. The file ships Tantibar and Mandelbar definitions. Knill writes the iterator as z̄ + c (degree 1), but with that literal map the connectedness locus is the imaginary axis — path-connected, contradicting the claim. The formal statement uses the standard degree-2 form.
- Source: John H. Hubbard and Dierk Schleicher, *Multicorns are not Path Connected*, arXiv:1209.1753 (2012); published in *Frontiers in Complex Dynamics* (Princeton University Press, 2014), pp. 73-102. Listed as §62 (additional statement 2) in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: This is the d = 2 case of Hubbard–Schleicher's theorem that no multicorn for d ≥ 2 is path-connected. They study the connectedness loci of unicritical antiholomorphic polynomials z ↦ z̄^d + c and show that certain odd-period hyperbolic components cannot be connected to the principal component by paths inside the multicorn. Specialising to d = 2 gives that the mandelbar / tricorn is not path-connected.

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
