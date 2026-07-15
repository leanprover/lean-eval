# `solvable_by_radicals_converse`

Solvable extensions ↔ solvable groups (the missing converse in Abel–Ruffini)

- Problem ID: `solvable_by_radicals_converse`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §58 of Knill's 'Some Fundamental Theorems in Mathematics' (additional statement). For F : Field of characteristic zero and a nonzero p : F[X], every root of p in AlgebraicClosure F lies in solvableByRad F (AlgebraicClosure F) iff p.Gal is solvable. Mathlib has the → direction via isSolvable_gal_of_irreducible / isSolvable_gal_minpoly in Mathlib/FieldTheory/AbelRuffini.lean (the file header states it proves 'one direction' of Abel–Ruffini). The ← direction is the Kummer-theory content and is the missing piece. The polynomial-level iff is stronger than the irreducible/minpoly form already in mathlib.
- Source: É. Galois (1832); the iff appears in standard texts such as Stewart, *Galois Theory* (Theorem 18.10); Lang, *Algebra* (VI §7); Rotman, *Galois Theory* (Theorem 73). Listed as §58 (additional statement 2) in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Classical proof of the ← direction: assume p.Gal is solvable. Adjoin to F a sufficient root of unity (a primitive n-th root for n = |p.Gal|) to obtain F' = F(ζ); the Galois group of the splitting field L of p over F' is a subgroup of Gal(p over F) hence still solvable, and F'/F is a radical extension. Take a composition series G = G₀ ▹ G₁ ▹ ⋯ ▹ Gₖ = 1 of Gal(L/F') with each factor cyclic of prime order. The corresponding tower of fixed fields is F' = L^{G₀} ⊂ L^{G₁} ⊂ ⋯ ⊂ L^{Gₖ} = L, with each step Galois cyclic of prime order over a field containing the relevant root of unity; by Kummer theory each step is a pure radical extension. The splitting field of p sits inside L, so every root of p lies in solvableByRad F (AlgebraicClosure F). The → direction follows from the existing mathlib lemma isSolvable_gal_of_irreducible applied to each irreducible factor.

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
