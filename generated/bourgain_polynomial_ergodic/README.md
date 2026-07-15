# `bourgain_polynomial_ergodic`

Bourgain's polynomial ergodic theorem

- Problem ID: `bourgain_polynomial_ergodic`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a measure-preserving system on a probability space, every integer-polynomial iterate sequence a, and every f ∈ L^p with p > 1, the polynomial ergodic averages (1/n) ∑_{k<n} f(T^[a k] x) converge pointwise almost everywhere. Trusted helpers (IsIntegerPolynomialSequence, polynomialErgodicAverage) are non-holes. Mathlib has Birkhoff's pointwise ergodic theorem but not Bourgain's polynomial extension. Candidate from §173 of the Knill survey.
- Source: J. Bourgain, *Pointwise ergodic theorems for arithmetic sets*, Publ. Math. IHÉS 69 (1989). Knill, *Some fundamental theorems in mathematics*, §173.
- Informal solution: Reduce, via a transfer/Calderón principle, to a maximal inequality for the discrete polynomial averaging operators on ℤ. Bourgain's proof establishes the L^p (p > 1) bound for the associated maximal function using circle-method / Hardy–Littlewood estimates: split the Fourier multiplier into major arcs (where it is approximated by a continuous averaging multiplier controlled by the Dunford–Schwartz/Wiener maximal theorem) and minor arcs (controlled by Weyl-type exponential sum bounds and a variational/oscillation argument). The maximal inequality, together with pointwise convergence on a dense subclass (e.g. eigenfunctions / bounded functions), yields a.e. convergence of the averages for all f ∈ L^p by the Banach principle. The limit F is the pointwise limit. Requires harmonic-analysis machinery absent from Mathlib.

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
