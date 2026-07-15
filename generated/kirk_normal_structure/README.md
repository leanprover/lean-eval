# `kirk_normal_structure`

Kirk's normal-structure fixed point theorem

- Problem ID: `kirk_normal_structure`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A nonexpansive (1-Lipschitz) self-map of a nonempty bounded closed convex subset K of a reflexive Banach space with normal structure has a fixed point. Reflexivity is expressed as genuine Banach reflexivity: surjectivity of NormedSpace.inclusionInDoubleDual ℝ E into the bidual; using Module.IsReflexive instead would collapse to the finite-dimensional case. Normal structure (HasNormalStructure) asks every nontrivial convex subset to contain a non-diametral point, with the diameter and point-radius written as real suprema. Mathlib has reflexivity, LipschitzWith, and convexity, but no normal-structure theory and no Kirk fixed-point theorem. Listed as §228 of the Knill survey.
- Source: W. A. Kirk, A fixed point theorem for mappings which do not increase distances, Amer. Math. Monthly 72 (1965). Listed as §228 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §228.
- Informal solution: By reflexivity and the Banach-Alaoglu/Eberlein-Šmulian theorem, the bounded closed convex set K is weakly compact, and the nonempty closed convex T-invariant subsets of K, ordered by reverse inclusion, have a minimal element K₀ (a weakly compact chain intersection is nonempty). If K₀ were a single point it is the fixed point. Otherwise K₀ is nontrivial; normal structure provides a non-diametral point, and averaging/Chebyshev-center arguments show the set of points whose radius in K₀ is minimal is a proper closed convex T-invariant subset of K₀, contradicting minimality. Hence K₀ is a point and T fixes it. Mathlib lacks weak compactness via reflexivity wired to this fixed-point argument, normal structure, and the Chebyshev-center step.

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
