# `wang_zahl_kakeya_dimH`

Wang-Zahl: the three-dimensional Kakeya conjecture

- Problem ID: `wang_zahl_kakeya_dimH`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Every compact subset K of Euclidean three-space that contains a unit line segment in every unit direction has Hausdorff dimension 3. The trusted IsKakeya definition includes compactness, explicitly quantifies over norm-one direction vectors v, and requires a translate of {t • v | 0 ≤ t ≤ 1} to lie in K. Full Hausdorff dimension also forces full lower and upper Minkowski dimension, so this captures both conclusions of Theorem 1.1. Mathlib supplies EuclideanSpace, the normed-space operations, and MeasureTheory.dimH, but not the Kakeya theorem or its tube-estimate machinery.
- Source: H. Wang and J. Zahl, 'Volume estimates for unions of convex sets, and the Kakeya set conjecture in three dimensions', Theorem 1.1, arXiv:2502.17655 (2025), https://arxiv.org/abs/2502.17655. The proof builds on their 'Sticky Kakeya sets and the sticky Kakeya conjecture', arXiv:2210.09581, and 'The Assouad dimension of Kakeya sets in R^3', arXiv:2401.12337.
- Informal solution: The upper bound dimH K ≤ 3 is the ambient Euclidean-dimension bound. For the lower bound, discretize the family of unit segments in K at a small scale δ, replacing them by a direction-separated family of δ-tubes. Wang and Zahl establish almost-maximal lower bounds for unions of tubes and their dense shadings under convex non-clustering hypotheses. Starting from Wolff's hairbrush estimate D(1/2, 0), their multi-scale argument combines grains decompositions, refined induction on scales, factorization, and a generalization of the previously established sticky Kakeya theorem to obtain the endpoint tube estimates D(0, 0) and E(0, 0). Applied across scales to the segments in K, these estimates force both the Minkowski and Hausdorff dimensions of K to be at least 3, hence exactly 3.

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
