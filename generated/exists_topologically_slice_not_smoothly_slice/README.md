# `exists_topologically_slice_not_smoothly_slice`

Existence of a topologically slice, not smoothly slice knot

- Problem ID: `exists_topologically_slice_not_smoothly_slice`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The smooth/topological gap in dimension four. Casson, Akbulut-Matveyev, and Hedden-Kirk-Livingston gave explicit witnesses; Piccirillo later resolved the Conway knot 11n34 — a much smaller, celebrated example of the same phenomenon. The solver may choose any witness. Topological sliceness here means bounding a *locally flat* topological 2-disk in R^3 x [0, infty); the locally flat clause is essential since without it the cone over any knot is a topological disk.
- Source: Casson, 1980s (unpublished); Akbulut-Matveyev, *A convex decomposition theorem for 4-manifolds*, IMRN 1998. See also Hedden-Kirk-Livingston, *Non-slice linear combinations of algebraic knots*, J. Eur. Math. Soc. 14 (2012).
- Informal solution: Take K = positive Whitehead double of a knot K_0 with tau(K_0) > 0 (e.g. the right-handed trefoil; Akbulut-Matveyev). Whitehead doubles always have trivial Alexander polynomial, so K is topologically slice by Freedman's theorem. The Ozsvath-Szabo tau-invariant of K equals tau(K_0) > 0, and tau is a smooth slice obstruction (tau != 0 implies not smoothly slice), so K is not smoothly slice.

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
