# `duffin_schaeffer`

Duffin-Schaeffer conjecture

- Problem ID: `duffin_schaeffer`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Mathlib's `addWellApproximable UnitAddCircle δ` is the limsup of the sets of points within distance `δ n` of a point of exact additive order `n`; these order-`n` points are exactly the reduced fractions with denominator `n`. Thus the theorem is the standard Duffin-Schaeffer criterion in radius notation: the limsup set has full Lebesgue measure iff `sum_n phi(n) * δ(n)` diverges. Nonnegativity of `δ` makes divergence equivalent to failure of `Summable`. The unit circle has total volume one.
- Source: D. Koukoulopoulos and J. Maynard, 'On the Duffin-Schaeffer conjecture', Ann. of Math. 192 (2020), 251-307, https://doi.org/10.4007/annals.2020.192.1.5.
- Informal solution: The convergence implication is the first Borel-Cantelli lemma. For the difficult divergence implication, Koukoulopoulos and Maynard reduce the problem to a quantitative second-moment estimate for overlaps between the sets of reduced rational approximations. They organize pairs of denominators by their greatest common divisor and by a graph encoding exceptional common prime factors. A compression argument and estimates for the resulting GCD sums show that any substantial failure of quasi-independence is confined to structured denominator sets whose total contribution can be controlled. This yields positive measure for the limsup set whenever `sum phi(n) * δ(n)` diverges; Gallagher's ergodic zero-one law, already formalized in Mathlib for `addWellApproximable`, upgrades positive measure to full measure.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
