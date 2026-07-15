# `brouwer_fixed_point`

Brouwer fixed-point theorem

- Problem ID: `brouwer_fixed_point`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §33 of Oliver Knill's 'Some Fundamental Theorems in Mathematics' (additional statement of the game-theory section; Brouwer underlies Nash's 1950 proof of equilibrium existence). Every continuous self-map of a nonempty compact convex K ⊆ ℝᵈ has a fixed point. Mathlib has the Banach fixed-point theorem (strictly weaker — needs Lipschitz < 1); `grep -ri brouwer` returns only Brouwerian lattices/logics. Brouwer is theorem #36 on Freek Wiedijk's 'Formalizing 100 Theorems' list and is formalized in Lean outside mathlib (per docs/100.yaml `links` entry), in Isabelle/AFP, HOL Light, and Coq.
- Source: L. E. J. Brouwer, Über Abbildung von Mannigfaltigkeiten, Math. Ann. 71 (1912). Listed as §33 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf); also #36 on Freek Wiedijk's 100 list (https://www.cs.ru.nl/~freek/100/).
- Informal solution: Reduce to the closed unit ball B^d via a homeomorphism (any nonempty compact convex K ⊆ ℝᵈ is homeomorphic to a closed ball of the appropriate dimension). On the ball, suppose for contradiction f has no fixed point; then for each x ∈ B^d the ray from f(x) through x meets ∂B^d in a unique point r(x), defining a continuous retraction r : B^d → ∂B^d with r|∂B^d = id. Such a retraction is impossible by a homotopy/homology argument (the sphere S^{d-1} is not contractible / has H_{d-1} = ℤ while the ball has trivial reduced homology), giving a contradiction. Alternative proofs go through Sperner's lemma, simplicial approximation, or homotopy invariance of degree.

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
