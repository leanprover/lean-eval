# `wallpaper_groups_17`

Seventeen wallpaper groups (Pólya–Niggli 1924)

- Problem ID: `wallpaper_groups_17`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: There are exactly 17 wallpaper groups, the discrete cocompact subgroups of the planar Euclidean motion group E_2, counted up to affine equivalence. Discreteness is encoded as a properly discontinuous action on ℝ² — local finiteness of the return set at each point — equivalent on subgroups of E_d to Knill's positive-minimal-distance formulation, and avoids equipping `E d ≃ᵃⁱ[ℝ] E d` with a topology (mathlib has no default topology on the affine-isometry equiv type). Cocompactness is encoded as containing d linearly independent translations. §94 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: G. Pólya, 'Über die Analogie der Kristallsymmetrie in der Ebene', Z. Kristallogr. 60 (1924) 278–282; P. Niggli, 'Die Flächensymmetrien homogener Diskontinuen', Z. Kristallogr. 60 (1924) 283–298. Listed as §94 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The classification proceeds in four steps. (1) **Bieberbach's first theorem** (1910): every crystallographic group G in dimension d contains a finite-index translation subgroup of rank d (the translation lattice Λ). (2) **Point group**: the quotient G / Λ embeds into O(d) and is finite; in dimension 2 it is one of the 10 finite subgroups {C₁, C₂, C₃, C₄, C₆, D₁, D₂, D₃, D₄, D₆} compatible with the **crystallographic restriction** (rotation orders ∈ {1, 2, 3, 4, 6}; orders 5 and ≥ 7 are excluded by the trace-rationality argument). (3) **Extension classification**: enumerate group extensions of each point group by each lattice it can preserve, classifying the relevant extensions via cocycles in group cohomology (H²(point group, Λ)) modulo affine conjugacy. (4) **Compatibility**: of the 17 candidate extensions, all 17 are realised by explicit examples (p1, p2, pm, pg, cm, pmm, pmg, pgg, cmm, p4, p4m, p4g, p3, p31m, p3m1, p6, p6m). Mathlib has `EuclideanSpace`, `AffineIsometryEquiv`, `AffineEquiv`, `LinearIndependent`, and `IsOfFinOrder`, but no wallpaper-group framework, no Bieberbach theorems, no point-group classification, no crystallographic-restriction theorem, no extension-cohomology classification in this dimension.

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
