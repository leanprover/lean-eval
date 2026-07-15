# `fatou_julia_dichotomy`

Fatou–Julia / Cantor dichotomy

- Problem ID: `fatou_julia_dichotomy`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For the quadratic family T_c(z) = z² + c, the filled Julia set K_c is connected when c is in the Mandelbrot set and homeomorphic to the Cantor space ℕ → Bool when c is not. §62 (additional statement 1) of Knill's 'Some Fundamental Theorems in Mathematics'. The submitted statement uses the filled Julia set rather than the boundary Julia set ∂K_c; this is equivalent for the dichotomy since K_c is connected iff ∂K_c is, and in the escaping case K_c = ∂K_c is a Cantor set.
- Source: P. Fatou, *Sur les équations fonctionnelles*, Bull. Soc. Math. France 47 (1919), 161-271; 48 (1920), 33-94, 208-314. G. Julia, *Mémoire sur l'itération des fonctions rationnelles*, J. Math. Pures Appl. 1 (1918), 47-245. Modern statement: A. Douady and J. H. Hubbard, *Étude dynamique des polynômes complexes I, II*, Publ. Math. Orsay 84-02, 85-04. Listed as §62 (additional statement 1) in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Connected case: use the standard theorem for polynomials that the filled Julia set is connected iff all critical orbits are bounded; for z² + c the only critical point is 0, so K_c is connected iff the orbit of 0 is bounded, i.e. iff c ∈ M. Escaping case: outside M the critical orbit escapes, K_c is compact, perfect, totally disconnected, and homeomorphic to Cantor space — the standard symbolic-dynamics conjugacy via the 2-branched preimages of a large invariant disc.

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
