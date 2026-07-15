# `bauer_extreme_point_uniqueness`

Bauer's uniqueness at extreme points

- Problem ID: `bauer_extreme_point_uniqueness`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: If x is an extreme point of a compact convex set K in a Banach space and μ is a probability measure on K (μ Kᶜ = 0) with barycenter x = ∫ y ∂μ, then μ is the Dirac mass at x. The support hypothesis is the weaker μ Kᶜ = 0, making this a strengthening of the textbook statement (uniqueness among all ambient Borel probability measures on K, not only those supported on ext K). Not in Mathlib (no Choquet simplices / Bauer's theorem); no new definitions. Companion candidate from §88 of the Knill survey.
- Source: H. Bauer, *Minimalstellen von Funktionen und Extremalpunkte*, Arch. Math. 9 (1958), 389–393; see also Phelps, *Lectures on Choquet's Theorem*. Knill, *Some fundamental theorems in mathematics*, §88.
- Informal solution: Since x is extreme, it is not a nontrivial convex combination, and the barycenter map is injective at extreme points. Argument: suppose μ ≠ δ_x. Then μ is not concentrated at x, so there is a closed half-space / continuous affine functional separating part of the mass; split μ = t·μ₁ + (1−t)·μ₂ with distinct barycenters b₁ ≠ b₂ both in K whose convex combination is x, contradicting extremality of x. Hence μ({x}) = 1, i.e. μ = Measure.dirac x. (Uses that the barycenter ∫ y ∂μ is well defined — μ Kᶜ = 0 with K compact makes id integrable.)

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
