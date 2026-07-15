# `hurewicz_h1_abelianization`

Hurewicz theorem in degree 1 (H₁ = abelianization of π₁)

- Problem ID: `hurewicz_h1_abelianization`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a path-connected space X, the first integral singular homology group is the abelianization of the fundamental group. Trusted helper IntegralHomology (non-hole). Path-connectedness is essential. Mathlib has singular homology and the fundamental group but not the degree-1 Hurewicz isomorphism. Candidate from §153 of the Knill survey.
- Source: W. Hurewicz (1935); see Hatcher, *Algebraic Topology*, Theorem 2A.1. Knill, *Some fundamental theorems in mathematics*, §153.
- Informal solution: Construct the natural map h : π₁(X,x) → H₁(X;ℤ) sending a loop to its singular 1-cycle. It kills commutators (H₁ is abelian), giving Φ : π₁^{ab} → H₁. Surjectivity: for path-connected X every 1-cycle is homologous to a sum of loops based at x (connect with paths). Injectivity: a loop bounding a 2-chain can be filled by a homotopy, using the path-connectedness to base everything at x. Hence Φ is an isomorphism. Requires comparing the simplicial/singular chain model with π₁, not in Mathlib.

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
