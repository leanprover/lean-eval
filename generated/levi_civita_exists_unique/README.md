# `levi_civita_exists_unique`

Fundamental theorem of Riemannian geometry (Levi-Civita)

- Problem ID: `levi_civita_exists_unique`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §38 of Knill's 'Some Fundamental Theorems in Mathematics'. On a C^∞ finite-dimensional Riemannian manifold, there exists a unique smooth torsion-free metric-compatible covariant derivative on TM (the Levi-Civita connection); uniqueness is stated on the smooth-section subspace via `SameOnSmooth` since mathlib's `CovariantDerivative` is bundled over all sections. Mathlib has the covariant-derivative / Riemannian-bundle / Lie-bracket machinery but no metric-compatibility predicate and no Levi-Civita existence/uniqueness.
- Source: T. Levi-Civita, Nozione di parallelismo in una varietà qualunque, Rend. Circ. Mat. Palermo 42 (1917). Listed as §38 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Existence + uniqueness via the Koszul formula. Solve 2·g(∇_X Y, Z) = X·g(Y,Z) + Y·g(X,Z) − Z·g(X,Y) − g(X,[Y,Z]) − g(Y,[X,Z]) + g(Z,[X,Y]) for the unknown ∇_X Y: the right-hand side is C^∞(M)-linear in Z and a derivation in Y, so by non-degeneracy of g it determines ∇_X Y as a smooth section. Direct verification that this `cov` is torsion-free and metric-compatible. For uniqueness: any other torsion-free metric-compatible smooth connection ∇' must satisfy the same Koszul identity, hence agrees with ∇ on smooth Y at every smooth X-direction.

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
