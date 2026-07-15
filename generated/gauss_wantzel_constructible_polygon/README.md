# `gauss_wantzel_constructible_polygon`

Gauss-Wantzel constructible regular polygon theorem

- Problem ID: `gauss_wantzel_constructible_polygon`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A regular n-gon is straightedge-and-compass constructible exactly when n is a Gauss-Wantzel integer: cos(2π/n) lies in the smallest subfield of ℝ closed under square roots iff every odd prime factor of n is a distinct Fermat prime (and the power of two is unconstrained). Constructibility is encoded by the inductive IsConstructible; the arithmetic side is GaussWantzelNumber. Mathlib has finite field extensions, cyclotomic theory, and minimal polynomials, but no straightedge-and-compass constructibility theory and no Gauss-Wantzel theorem.
- Source: C. F. Gauss, Disquisitiones Arithmeticae (1801), §365-366; P. L. Wantzel, Recherches sur les moyens de reconnaître si un problème de géométrie peut se résoudre avec la règle et le compas, J. Math. Pures Appl. 1 (1837). Listed as §174 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §174.
- Informal solution: Constructible numbers are exactly those reached from ℚ by a tower of degree-2 extensions, so a constructible real lies in a field of degree a power of 2 over ℚ. The number cos(2π/n) generates a subfield of the real cyclotomic field ℚ(ζ_n)⁺ of degree φ(n)/2 over ℚ. Hence cos(2π/n) is constructible iff φ(n) is a power of 2, which by the multiplicativity of Euler's totient and φ(p^k) = p^{k-1}(p-1) holds iff every odd prime factor p of n is a Fermat prime occurring to the first power only. The reverse direction builds the constructions explicitly via repeated square roots from the Gauss period decomposition. Formalizing this needs the constructible-tower equivalence (Wantzel's degree criterion) and the cyclotomic degree computation, neither connected up in Mathlib.

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
