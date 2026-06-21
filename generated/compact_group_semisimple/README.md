# `compact_group_semisimple`

Complete reducibility for compact groups

- Problem ID: `compact_group_semisimple`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A continuous representation of a compact topological group on a finite-dimensional real vector space is semisimple: every subrepresentation has a G-invariant complement (Representation.IsSemisimpleRepresentation). Mathlib has the semisimplicity predicate and Maschke's theorem for finite groups but no compact-group / Peter–Weyl / unitarian-trick result. Continuity of the action G × V → V and finite dimensionality are essential hypotheses. Candidate from §21 of the Knill survey.
- Source: H. Weyl, *Theorie der Darstellung kontinuierlicher halb-einfacher Gruppen durch lineare Transformationen* (1925–26); Peter–Weyl (1927). Knill, *Some fundamental theorems in mathematics*, §21.
- Informal solution: Apply the unitarian trick. Start from any inner product ⟨·,·⟩₀ on V and average it over the group using normalized Haar measure: ⟨u,v⟩ = ∫_G ⟨ρ(g) u, ρ(g) v⟩₀ dg. Compactness gives a finite total Haar measure and joint continuity makes the integrand continuous, so the integral exists; the result is a positive-definite G-invariant inner product, i.e. ρ acts by isometries. For any subrepresentation W, its orthogonal complement W^⊥ with respect to this invariant inner product is again G-invariant and is a complement of W. Hence every subrepresentation is complemented, which is exactly IsSemisimpleRepresentation.

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
