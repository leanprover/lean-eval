# `choquet_representation_theorem`

Choquet's representation theorem

- Problem ID: `choquet_representation_theorem`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: In a Banach space, every point of a compact convex set K is the barycenter ∫ y ∂μ of a probability measure μ supported on the extreme points of K (μ (ext K)ᶜ = 0). A norm-compact set is metrizable, so the extreme points are Borel and Choquet's theorem proper applies; the literal 'supported on ext K' rendering is faithful. Mathlib has Krein–Milman (closure_convexHull_extremePoints) and Convex.integral_mem but not Choquet's theorem, and no measure-theoretic barycenter operator. No new definitions beyond Mathlib's Set.extremePoints, IsProbabilityMeasure, and the Bochner integral. Candidate from §88 of the Knill survey.
- Source: G. Choquet, *Existence et unicité des représentations intégrales au moyen des points extrémaux dans les cônes convexes*, Séminaire Bourbaki (1956). Knill, *Some fundamental theorems in mathematics*, §88.
- Informal solution: For metrizable compact convex K, build the representing measure by the classical Choquet argument: choose a strictly convex lower-semicontinuous function and maximize ∫ over probability measures with barycenter x; a maximizer is supported on the extreme points (a non-extreme support point would admit a dilation strictly increasing the integral). Concretely, take a strictly convex continuous f, let μ maximize ∫ f over the (weak-* compact, convex) set of probability measures with barycenter x; maximality in the Choquet ordering forces a maximal representing measure, which in the metrizable compact case can be chosen supported on ext K. Use Krein–Milman / Bauer's maximum principle and the Choquet ordering on measures.

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
