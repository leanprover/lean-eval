# `coherent_cohomology_finite_dimensional`

Coherent cohomology of a proper scheme over ℚ is finite-dimensional

- Problem ID: `coherent_cohomology_finite_dimensional`
- Test Problem: no
- Submitter: Brian Nugent
- Notes: Grothendieck's coherent finiteness theorem: for a coherent sheaf M on a scheme X proper over ℚ, every cohomology group Hⁿ(X, M) is finite-dimensional over ℚ. Coherence is encoded as IsQuasicoherent together with IsFiniteType, which is coherent because properness makes X locally Noetherian. `M.sheaf.H n` is the degree-n sheaf cohomology (Ext from the constant ℤ-sheaf) of the underlying abelian sheaf of M; for a quasi-coherent sheaf this computes coherent cohomology. Mathlib exposes only the underlying abelian group of this cohomology, so the statement tensors with ℚ over ℤ: for the ℚ-vector space Hⁿ(X, M) the natural map V → ℚ ⊗[ℤ] V is an isomorphism, hence Module.Finite ℚ (ℚ ⊗[ℤ] M.sheaf.H n) faithfully expresses finite-dimensionality of the cohomology.
- Source: https://leanprover.zulipchat.com/#narrow/channel/583341-Model-comparisons-for-Lean/topic/LeanEval/near/603798763
- Informal solution: Prove it through a series of reductions. First do the case of projective space using Čech cohomology. Then do projective schemes. Finally use Chow's lemma along with dévissage for the general case.

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
