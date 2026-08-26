# `budney_gabai_knotted_three_spheres`

Budney--Gabai knotted three-spheres in S¹ × S³

- Problem ID: `budney_gabai_knotted_three_spheres`
- Group: `formalization-evaluation`
- Status: `active`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Vasily Ilin
- Notes: Corollary 8.6: S¹ × S³ contains infinitely many isotopy classes of nonseparating smoothly embedded S³s homotopic to a standard cross-section. The statement uses Mathlib's unit spheres and smooth-manifold API directly. Unparameterized smooth isotopy is encoded by a jointly smooth interval-family of embeddings whose endpoint ranges agree; this is equivalent to ambient smooth isotopy by isotopy extension.
- Source: R. Budney and D. Gabai, 'Knotted 3-balls in S⁴', Corollary 8.6, arXiv:1912.09029v3 (2021), https://arxiv.org/abs/1912.09029.
- Informal solution: Budney and Gabai construct barbell diffeomorphisms β_{δₖ} for k ≥ 4. Their W₃ invariant proves in Theorem 8.5 that the resulting classes are linearly independent even after quotienting by diffeomorphisms supported in a 4-ball. Applying these diffeomorphisms to the standard cross-section {x₀} × S³ gives nonseparating embedded three-spheres homotopic to the cross-section; isotopy of two such spheres would put the corresponding diffeomorphisms in the same quotient class, contradicting that independence.

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
