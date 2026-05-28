import Mathlib
import EvalTools.Markers

/-!
# Adapting families of maps to open covers (Morrison–Walker, *The Blob Complex*)

Lemma B.0.1 of Morrison and Walker, *The Blob Complex* (arXiv:1009.5025,
Appendix B, pp. 93–96):
<https://arxiv.org/pdf/1009.5025>.

Given a continuous family `f : P × X → T` parametrised by a convex linear
polyhedron `P ⊆ ℝᵏ` and a partition of unity subordinate to an open cover
`U` of a compact space `X`, the lemma produces a homotopy `F` from `f` to
a family that is *adapted* to `U` on each closed cell of a polyhedral
subdivision of `P`, with support preserved both absolutely and along
boundary subpolyhedra.

We state two cases:

* `morrison_walker_b01_continuous` — the continuous case (clauses 1–3 of
  the paper). The conclusion already carries a polyhedral subdivision,
  which is what makes Lemma B.0.2 (the chain-level deformation retract)
  a consequence at the chain complex level: adjacent cells share
  `(k−1)`-faces with cancelling orientations.

* `morrison_walker_b01_biLipschitz` — the bi-Lipschitz variant of clause
  4. The slices `f (p, ·)` are bundled as homeomorphisms `X ≃ₜ T` so that
  surjectivity is part of the data, the paper's joint Lipschitz
  hypothesis ("`f` is Lipschitz in the `P` direction as well") is
  imposed via `LipschitzWith L f.toFun`, and the conclusion produces
  the same bundled bi-Lipschitz homeomorphism structure on every slice
  `F (t, p, ·)`.

The variants for smooth diffeomorphisms / immersions / PL homeomorphisms
are omitted. The paper does *not* prove the analogous statement for
plain (merely continuous) homeomorphisms, and we do not state it.
-/

open Set unitInterval Geometry
open scoped Topology

namespace LeanEval
namespace Topology

namespace AdaptingFamilies

variable {k : ℕ} {ι X T : Type*}
  [TopologicalSpace X] [TopologicalSpace T]

/-- `Supported f S`: outside `S ⊆ X`, the family `f : P × X → T` is
parameter-independent. -/
def Supported {P : Type*} (f : P × X → T) (S : Set X) : Prop :=
  ∀ p p' : P, ∀ x ∉ S, f (p, x) = f (p', x)

/-- `AdaptedTo U k f`: `f` is supported on the union of at most `k` of the
sets `U α`. -/
def AdaptedTo {P : Type*} (U : ι → Set X) (k : ℕ) (f : P × X → T) : Prop :=
  ∃ A : Finset ι, A.card ≤ k ∧ Supported f (⋃ α ∈ A, U α)

/-- A *convex linear polyhedron* in `ℝᵏ`: the convex hull of a finite set
(equivalently, a bounded intersection of finitely many half-spaces). -/
def IsPolyhedron (P : Set (Fin k → ℝ)) : Prop :=
  ∃ S : Finset (Fin k → ℝ), P = convexHull ℝ (S : Set _)

/-- A *polyhedral subdivision* of a polyhedron `P ⊆ ℝᵏ`: a finite geometric
simplicial complex whose underlying space equals `P`. -/
structure Subdivision (P : Set (Fin k → ℝ)) where
  complex      : SimplicialComplex ℝ (Fin k → ℝ)
  faces_finite : complex.faces.Finite
  space_eq     : complex.space = P

/-- The closed cell associated with a face `D`, as a subset of `P`. -/
def closedCell (P : Set (Fin k → ℝ)) (D : Finset (Fin k → ℝ)) : Set P :=
  { p | (p : Fin k → ℝ) ∈ convexHull ℝ (D : Set (Fin k → ℝ)) }

/-- A *boundary subpolyhedron* of `P`: a subset of `P` whose image in `ℝᵏ`
is itself a polyhedron and lies in the *intrinsic* frontier of `P` (the
boundary of `P` taken inside `affineSpan ℝ P`, so this is non-trivial
even when `P` is lower-dimensional in `ℝᵏ`). -/
def IsBoundarySubpolyhedron {P : Set (Fin k → ℝ)} (Q : Set P) : Prop :=
  (∃ S : Finset (Fin k → ℝ),
      ((↑) : P → Fin k → ℝ) '' Q = convexHull ℝ (S : Set (Fin k → ℝ))) ∧
    ((↑) : P → Fin k → ℝ) '' Q ⊆ intrinsicFrontier ℝ P

end AdaptingFamilies

open AdaptingFamilies

/-- **Lemma B.0.1** of Morrison–Walker, *The Blob Complex*
(arXiv:1009.5025, §B), continuous case.

Given a polyhedron `P ⊆ ℝᵏ`, a compact space `X` with an open cover `U`
and a subordinate partition of unity `ρ`, and a continuous family
`f : P × X → T`, there exists a continuous homotopy `F : I × P × X → T`
such that
1. `F` restricts to `f` at time `0`;
2. there is a polyhedral subdivision `K` of `P` such that on each closed
   facet of `K` the time-`1` family is adapted to `U`;
3a. `F`, parametrised by `I × P`, has the same support as `f`;
3b. for any boundary subpolyhedron `Q ⊆ ∂P` on which `f` has support `S'`,
    the family `F` parametrised by `I × Q` has support `S'` too. -/
@[eval_problem]
theorem morrison_walker_b01_continuous
    {k : ℕ} {ι X T : Type*} [TopologicalSpace X] [TopologicalSpace T]
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
            Supported (fun q : (I × Q) × X => F (q.1.1, q.1.2.1, q.2)) S') := by
  sorry

/-- **Lemma B.0.1**, bi-Lipschitz variant (part 4 of the paper).

Slices `f (p, ·)` are bundled as homeomorphisms `slice p : X ≃ₜ T`
(capturing surjectivity), the paper's joint Lipschitz assumption ("`f`
is Lipschitz in the `P` direction as well") is required via
`LipschitzWith L f.toFun`, and a uniform Lipschitz constant for the
inverse slice is supplied.

The conclusion produces the same bundled bi-Lipschitz homeomorphism
structure for each slice `F (t, p, ·)`. -/
@[eval_problem]
theorem morrison_walker_b01_biLipschitz
    {k : ℕ} {X T : Type*} [MetricSpace X] [MetricSpace T] [CompactSpace X]
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
      (∀ tp : I × P, LipschitzWith L' (Slice tp).symm) := by
  sorry

end Topology
end LeanEval
