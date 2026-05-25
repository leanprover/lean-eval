# `platonic_classification`

Platonic classification

- Problem ID: `platonic_classification`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §42 of Knill's 'Some Fundamental Theorems in Mathematics'. The count p_d of regular convex d-polytopes (Platonic polytopes) up to similarity is p_2 = ∞ (regular polygons), p_3 = 5 (Euclid XIII), p_4 = 6 (Schläfli 1850s), and p_d = 3 for d ≥ 5. Mathlib has convexHull, extremePoints, IsExposed, vectorSpan, AffineIsometryEquiv, Set.encard but no convex-polytope datatype, no face lattice, no regular-polytope concept, and none of the classification counts. The Challenge ships ~1.5 pages of helper defs (ConvexPolytope, dim, IsFace, Flag, isSymmetry, IsRegular, Similar, regularPolytopes, regularSimilar, platonicCount).
- Source: Euclid, Elements, Book XIII (~300 BC, p_3 = 5); L. Schläfli, Theorie der vielfachen Kontinuität (1852, posthumous publication; p_4 = 6, p_d = 3 for d ≥ 5). Listed as §42 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: p_2 = ⊤: for each n ≥ 3 the regular n-gon (vertices = n-th roots of unity) is regular and any two non-congruent regular polygons are non-similar; the construction gives infinitely many similarity classes. p_3 = 5: any regular 3-polytope has Schläfli symbol {p, q} with p, q ≥ 3 and 1/p + 1/q > 1/2 (the spherical-angle-sum constraint at each vertex), giving exactly (3,3), (4,3), (3,4), (5,3), (3,5) — the five Platonic solids. p_4 = 6: any regular 4-polytope {p, q, r} satisfies the analogous spherical inequality, giving (3,3,3), (4,3,3), (3,3,4), (3,4,3), (5,3,3), (3,3,5) — Schläfli's six. p_d ≥ 5 = 3: in dim ≥ 5 the only solutions to the iterated angle constraint are the regular simplex {3, …, 3, 3}, hypercube {4, 3, …, 3}, and cross-polytope {3, …, 3, 4}. Existence of each candidate is by explicit construction (vertex coordinates); uniqueness within Schläfli class is by induction on dimension via vertex figures.

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
