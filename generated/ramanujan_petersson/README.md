# `ramanujan_petersson`

Ramanujan–Petersson conjecture for the τ-function (Deligne's theorem)

- Problem ID: `ramanujan_petersson`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Seewoo Lee
- Notes: τ(n) is the n-th q-expansion coefficient of mathlib's modular discriminant ModularForm.discriminant = η²⁴, the normalised cusp form of weight 12 and level 1; the module proves τ(1) = 1 as a sanity check. Ramanujan (1916) conjectured |τ(p)| ≤ 2 p^(11/2) for every prime p; Petersson generalised it to all cusp forms, and Deligne proved it in 1974 from the Weil conjectures. The coefficients are a priori complex (integrality is classical but not needed to state the bound), so the statement bounds the complex norm ‖τ(p)‖.
- Source: S. Ramanujan, 'On certain arithmetical functions', Trans. Cambridge Philos. Soc. 22 (1916) 159–184. H. Petersson, 'Theorie der automorphen Formen beliebiger reeller Dimension und ihre Darstellung durch eine neue Art Poincaréscher Reihen', Math. Ann. 103 (1930) 369–436. P. Deligne, 'Formes modulaires et représentations ℓ-adiques', Séminaire Bourbaki 1968/69: Exposés 347–363, Lecture Notes in Math. 179, Springer (1971). P. Deligne, 'La conjecture de Weil. I', Publ. Math. IHÉS 43 (1974) 273–307. Background: https://en.wikipedia.org/wiki/Ramanujan%E2%80%93Petersson_conjecture
- Informal solution: Deligne's proof: the ℓ-adic Galois representation attached to Δ (Eichler–Shimura, Deligne) realises τ(p) as the trace of Frobenius on a weight-11 piece of the étale cohomology of the universal elliptic curve over the modular curve, and Deligne's proof of the Weil conjectures (1974) gives Frobenius eigenvalues α, β with αβ = p¹¹ and |α| = |β| = p^(11/2), hence |τ(p)| = |α + β| ≤ 2 p^(11/2).

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
