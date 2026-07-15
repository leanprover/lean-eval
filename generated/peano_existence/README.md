# `peano_existence`

Peano existence theorem for ODEs

- Problem ID: `peano_existence`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: If f is continuous, the autonomous initial value problem x'(t) = f(x(t)), x(0) = x₀ admits a local solution on some interval (-a, a); uniqueness may fail (e.g. x' = √x, x(0) = 0). Stated for a finite-dimensional space, since Peano's theorem requires local compactness and is false in general (infinite-dimensional) Banach spaces (Dieudonné). Mathlib has Arzelà–Ascoli (the key ingredient) but not Peano's theorem itself. Candidate from §19 of the Knill survey.
- Source: G. Peano, *Démonstration de l'intégrabilité des équations différentielles ordinaires*, Math. Ann. 37 (1890). Knill, *Some fundamental theorems in mathematics*, §19.
- Informal solution: Construct approximate solutions via Euler polygons (or Tonelli/Picard approximations) with mesh tending to zero. The continuity of f and finite dimensionality give a uniform bound on the family near x₀, so the approximants are uniformly bounded and equicontinuous on a small interval (-a, a). By the Arzelà–Ascoli theorem a subsequence converges uniformly to a limit α; passing to the limit in the integral equation α(t) = x₀ + ∫₀ᵗ f(α(s)) ds shows α solves the ODE with α(0) = x₀, giving HasDerivAt α (f (α t)) t. Local compactness is essential and fails in infinite dimensions.

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
