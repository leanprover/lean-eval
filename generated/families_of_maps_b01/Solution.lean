import Mathlib
import Submission
import ChallengeDeps
/-!
# Adapting families of maps to open covers (Morrison–Walker, *The Blob Complex*)

Lemma B.0.1 of Morrison and Walker, *The Blob Complex* (arXiv:1009.5025,
Appendix B, pp. 93–96): <https://arxiv.org/pdf/1009.5025>.

Given a continuous family `f : P × X → T` parametrised by a convex linear
polyhedron `P ⊆ ℝᵏ` and a partition of unity subordinate to an open cover
`U` of a compact space `X`, the lemma produces a homotopy `F` from `f` to
a family that is *adapted* to `U` on each closed cell of a polyhedral
subdivision of `P`, with support preserved both absolutely and along
boundary subpolyhedra.

Two holes:

* `FamiliesOfMapsB01.continuous` — the continuous case (clauses 1–3 of
  the paper). The polyhedral-subdivision conclusion is what makes
  Lemma B.0.2 (the chain-level deformation retract) a chain-complex
  consequence: each closed cell is a generator of `C∗(Maps(X → T))` and
  adjacent cells share `(k−1)`-faces with cancelling orientations.

* `FamiliesOfMapsB01.biLipschitz` — the bi-Lipschitz variant of clause 4.
  Each slice `f (p, ·)` is bundled as a homeomorphism `X ≃ₜ T` (so
  surjectivity is part of the data), the paper's joint Lipschitz
  hypothesis ("`f` is Lipschitz in the `P` direction as well") is
  imposed via `LipschitzWith L f.toFun`, and the conclusion produces the
  same bundled bi-Lipschitz homeomorphism structure on every slice
  `F (t, p, ·)`.

The smooth-diffeomorphism / immersion / PL variants are omitted. The
paper does *not* prove the analogous statement for plain (merely
continuous) homeomorphisms, and we do not state it.

The trusted supporting definitions (`Supported`, `AdaptedTo`,
`IsPolyhedron`, `Subdivision`, `closedCell`, `IsBoundarySubpolyhedron`)
are factored into `ChallengeDeps.lean` automatically by the multi-hole
generator.

This statement was corrected on 2026-06-14: the original
`IsBoundarySubpolyhedron` admitted any convex hull of frontier points,
including single non-vertex points of `∂P`, for which condition 4's
support hypothesis is vacuous and spuriously forced the homotopy to
freeze those points in time — making the lemma false. Lorenzo Luccioli,
using Harmonic's Aristotle, gave a formal disproof. The repair restricts
boundary subpolyhedra to genuine faces of `P` (`IsExtreme ℝ P`), matching
the paper's "convex linear subpolyhedron of `∂P`". Thanks to both.
-/

open Set unitInterval Geometry
open scoped Topology

namespace FamiliesOfMapsB01

variable {k : ℕ} {ι X T : Type*}
  [TopologicalSpace X] [TopologicalSpace T]













/-- **Lemma B.0.1** of Morrison–Walker, *The Blob Complex*
(arXiv:1009.5025, §B), continuous case. -/
theorem continuous
    {P : Set (Fin k → ℝ)} (_hP : IsPolyhedron P)
    [CompactSpace X]
    (U : ι → Set X) (_hUopen : ∀ α, IsOpen (U α))
    (ρ : PartitionOfUnity ι X univ) (_hρ : ρ.IsSubordinate U)
    (f : C(P × X, T)) :
    ∃ F : C(I × P × X, T),
      (∀ p : P, ∀ x : X, F (0, p, x) = f (p, x)) ∧
      (∃ K : Subdivision P,
         ∀ D ∈ K.complex.facets,
            AdaptedTo U k
              (fun q : closedCell P D × X => F (1, q.1.1, q.2))) ∧
      (∀ S : Set X, Supported (f := f.toFun) S →
          Supported (fun q : (I × P) × X => F (q.1.1, q.1.2, q.2)) S) ∧
      (∀ Q : Set P, IsBoundarySubpolyhedron Q →
        ∀ S' : Set X,
          Supported (fun q : Q × X => f (q.1.1, q.2)) S' →
            Supported (fun q : (I × Q) × X => F (q.1.1, q.1.2.1, q.2)) S') := Submission.FamiliesOfMapsB01.continuous _hP U _hUopen ρ _hρ f

/-- **Lemma B.0.1**, bi-Lipschitz variant (part 4 of the paper). -/
theorem biLipschitz
    {X T : Type*} [MetricSpace X] [MetricSpace T] [CompactSpace X]
    {P : Set (Fin k → ℝ)} (_hP : IsPolyhedron P)
    {ι : Type*}
    (U : ι → Set X) (_hUopen : ∀ α, IsOpen (U α))
    (ρ : PartitionOfUnity ι X univ) (_hρ : ρ.IsSubordinate U)
    (f : C(P × X, T))
    (slice : P → (X ≃ₜ T))
    (_h_slice_eq : ∀ p : P, ∀ x : X, f (p, x) = slice p x)
    (L : NNReal)
    (_hf_joint     : LipschitzWith L f.toFun)
    (_hf_slice_inv : ∀ p : P, LipschitzWith L (slice p).symm) :
    ∃ F : C(I × P × X, T), ∃ L' : NNReal, ∃ Slice : I × P → (X ≃ₜ T),
      (∀ p : P, ∀ x : X, F (0, p, x) = f (p, x)) ∧
      (∀ t : I, ∀ p : P, ∀ x : X, F (t, p, x) = Slice (t, p) x) ∧
      (∃ K : Subdivision P,
         ∀ D ∈ K.complex.facets,
            AdaptedTo U k
              (fun q : closedCell P D × X => F (1, q.1.1, q.2))) ∧
      (∀ S : Set X, Supported (f := f.toFun) S →
          Supported (fun q : (I × P) × X => F (q.1.1, q.1.2, q.2)) S) ∧
      (∀ Q : Set P, IsBoundarySubpolyhedron Q →
        ∀ S' : Set X,
          Supported (fun q : Q × X => f (q.1.1, q.2)) S' →
            Supported (fun q : (I × Q) × X => F (q.1.1, q.1.2.1, q.2)) S') ∧
      (∀ tp : I × P, LipschitzWith L' (Slice tp)) ∧
      (∀ tp : I × P, LipschitzWith L' (Slice tp).symm) := Submission.FamiliesOfMapsB01.biLipschitz _hP U _hUopen ρ _hρ f slice _h_slice_eq L _hf_joint _hf_slice_inv

end FamiliesOfMapsB01
