# `banach_alaoglu_bourbaki`

Bourbaki's locally convex extension of Banach–Alaoglu

- Problem ID: `banach_alaoglu_bourbaki`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §137 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. Bourbaki's locally convex Banach–Alaoglu theorem states that, for any real locally convex topological vector space E, the weak-star polar of a neighbourhood of 0 is compact in the weak dual. This extends the familiar normed-space Banach–Alaoglu theorem from closed dual balls to polars of zero-neighbourhoods in arbitrary locally convex spaces. Mathlib currently has the normed-space results WeakDual.isCompact_closedBall and WeakDual.isCompact_polar, but no corresponding compactness theorem for general locally convex spaces.
- Source: N. Bourbaki, Espaces vectoriels topologiques; the normed case is L. Alaoglu, Ann. of Math. 41 (1940). Listed as §137 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Realise each functional φ ∈ WeakDual ℝ E by its restriction to the neighbourhood U, embedding the polar into the product ∏_{x ∈ U} [−1, 1] (φ ↦ (φ x)). The polar maps into this product because |φ x| ≤ 1 on U; by Tychonoff the product is compact. The image is closed: the conditions ‖φ x‖ ≤ 1 (closed) and linearity/continuity of φ (preserved under pointwise limits, using that U absorbs E so a pointwise limit of equicontinuous functionals is again continuous and linear) are closed in the product topology, which coincides with the weak-star topology on the polar. Hence the polar is a closed subset of a compact space, so compact.

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
