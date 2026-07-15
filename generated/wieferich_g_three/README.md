# `wieferich_g_three`

Wieferich's theorem g(3) = 9

- Problem ID: `wieferich_g_three`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every natural number is a sum of nine cubes, and nine is necessary (23 is not a sum of eight cubes): the k=3 case of the Hilbert–Waring problem, g(3) = 9. The trusted helper IsSumOfCubes (non-hole) fixes 'sum of k cubes'. Mathlib has Lagrange's four-square theorem but no Hilbert–Waring material (no g(k), no sum-of-cubes predicate, no g(3)=9). Candidate from §76 of the Knill survey.
- Source: A. Wieferich, *Beweis des Satzes, daß sich eine jede ganze Zahl als Summe von höchstens neun positiven Kuben darstellen läßt*, Math. Ann. 66 (1909); A. Kempner, *Über das Waringsche Problem und einige Verallgemeinerungen*, Math. Ann. 72 (1912). Knill, *Some fundamental theorems in mathematics*, §76.
- Informal solution: Two parts. Upper bound (g(3) ≤ 9, every n is a sum of nine cubes): the classical Wieferich–Kempner argument — reduce to a bounded range via the identity expressing six consecutive integers' cubes and the fact that every sufficiently large n is a sum of at most eight cubes (Linnik/Watson give 8 for large n), then check the finite remaining range by computation, the worst cases being 23 and 239 (both of which need nine cubes). Lower bound (g(3) ≥ 9): exhibit n = 23, whose only cube summands ≤ 23 are 1 and 8; 23 = 2·8 + 7·1 uses nine cubes and a short case analysis shows no representation uses eight or fewer.

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
