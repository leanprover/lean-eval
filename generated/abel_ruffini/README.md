# `abel_ruffini`

Abel–Ruffini theorem

- Problem ID: `abel_ruffini`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §57 of Oliver Knill's 'Some Fundamental Theorems in Mathematics' gives the Abel–Ruffini theorem in degree-threshold form: for each n ≥ 1, every complex root of every degree-n rational polynomial lies in solvableByRad ℚ ℂ if and only if n ≤ 4. This packages solvability of all linear, quadratic, cubic, and quartic equations by radicals together with the failure of such a universal statement from degree five onward. Mathlib defines solvableByRad and proves the direction from radical solvability of a root to solvability of the associated Galois group, and the Archive contains a specific nonsolvable quintic, but Mathlib does not currently contain this full degree-boundary theorem. Distinct from the existing solvable_by_radicals_converse problem (the per-polynomial Galois characterization).
- Source: P. Ruffini (1799), N. H. Abel (1824), É. Galois (1832). Listed as §57 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf); the general-quintic insolvability is #16 on Freek Wiedijk's 'Formalizing 100 Theorems' list (https://www.cs.ru.nl/~freek/100/).
- Informal solution: For n ≤ 4: every degree-n polynomial over ℚ has a solvable Galois group (subgroups of S₄ are solvable), and by the Galois correspondence for radical extensions (Kummer theory in characteristic zero) a solvable Galois group implies every root lies in solvableByRad — concretely the Cardano formula for cubics and the Ferrari/resolvent reduction for quartics exhibit the roots by radicals. For n ≥ 5: exhibit one degree-n polynomial whose Galois group is not solvable (e.g. a polynomial reducing to X⁵−4X+2 with Galois group S₅, padded by linear factors to degree n), so by the forward direction of Abel–Ruffini some root is not in solvableByRad, refuting the universally-quantified left-hand side. Combining, the iff holds exactly at the boundary n ≤ 4.

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
