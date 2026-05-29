# `families_of_maps_b01`

Morrison–Walker Lemma B.0.1: adapting families of maps to open covers

- Problem ID: `families_of_maps_b01`
- Test Problem: no
- Submitter: Kim Morrison
- Holes (2): `FamiliesOfMapsB01.continuous` (theorem), `FamiliesOfMapsB01.biLipschitz` (theorem)
- Notes: Lemma B.0.1 of Morrison–Walker, *The Blob Complex* (arXiv:1009.5025, Appendix B, pp. 93–96). Two holes that must both be filled: `FamiliesOfMapsB01.continuous` is the continuous case (clauses 1–3); `FamiliesOfMapsB01.biLipschitz` is the bi-Lipschitz variant of clause 4. Given a continuous family `f : P × X → T` parametrised by a convex linear polyhedron `P ⊆ ℝᵏ` and a partition of unity subordinate to an open cover `U` of a compact space `X`, produce a continuous homotopy `F : I × P × X → T` from `f` to a family adapted to `U` on each closed cell of a polyhedral subdivision of `P`, with support preserved on `I × P` and along boundary subpolyhedra `I × Q ⊆ I × ∂P`. The polyhedral-subdivision conclusion (rather than a loose closed cover) is what makes Lemma B.0.2 (the chain-level deformation retract) a chain-complex consequence: each closed cell is a generator of C∗(Maps(X → T)) and adjacent cells share (k−1)-faces with cancelling orientations. The bi-Lipschitz variant bundles each slice as a homeomorphism `slice p : X ≃ₜ T` (capturing surjectivity), imposes the paper's joint Lipschitz hypothesis ('f is Lipschitz in the P direction as well') via `LipschitzWith L f.toFun`, and concludes the same bundled bi-Lipschitz homeomorphism structure for every slice `F (t, p, ·)`. The smooth-diffeomorphism / immersion / PL variants are not stated. The paper explicitly does *not* prove the analogous statement for plain continuous homeomorphisms (cf. remark at the end of Appendix B; only Edwards–Kirby's 1-parameter version is known). Supporting definitions `Supported`, `AdaptedTo`, `IsPolyhedron`, `Subdivision`, `closedCell`, `IsBoundarySubpolyhedron` are trusted infrastructure rather than holes — the multi-hole pipeline factors them into `ChallengeDeps.lean`. Mathlib has `Geometry.SimplicialComplex`, `PartitionOfUnity`, `intrinsicFrontier`, `ContinuousMap`, `LipschitzWith`, etc. — what is missing is the polyhedral-subdivision API and the lemma itself.
- Source: S. Morrison and K. Walker, *The Blob Complex*, arXiv:1009.5025, Appendix B, Lemma B.0.1 (pp. 93–96): https://arxiv.org/pdf/1009.5025
- Informal solution: Choose for each cover index α a cell decomposition Kα of P in general position with respect to each other, with a common refinement L. For each top k-cell C of each Kα, pick a point p(C, α) ∈ C (along boundaries when C meets ∂P). On each k-handle D of L̃ define u(t, p, x) := (1−t) p + t Σα rα(x) p(D, α), and extend u inductively over lower-dimensional handles of L̃ via the product structure of each (k−j)-handle E ≃ B^{k−j} × B^j using auxiliary functions ηβⁱ : B^j → [0, 1] that form a partition of unity in the normal direction (formula (B.1) in the paper). Set F(t, p, x) := f(u(t, p, x), x). Then F is continuous, F(0, ·, ·) = f, F(1, ·, ·) restricted to a top handle D of L̃ depends on x only through the at-most-k partition functions rα that vary across D's chosen points (so each handle is adapted), and F preserves the support of f on I × P and on I × Q for any subpolyhedral Q ⊆ ∂P (because u maps I × Q × X into Q). For the bi-Lipschitz variant: the same construction works. The slice regularity follows from the chain rule ∂F/∂x = ∂f/∂x + (∂f/∂p)(∂u/∂x), where ∂f/∂x is bi-Lipschitz with constant L uniformly in p (compactness of P), ∂f/∂p is bounded by the joint Lipschitz constant L, and ∂u/∂x is made small by choosing the Kα sufficiently fine — so F(t, p, ·) is bi-Lipschitz with a constant L' close to L.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
