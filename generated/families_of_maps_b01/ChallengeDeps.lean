import Mathlib

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

/-- A *boundary subpolyhedron* of `P`: a **face** of `P` (an `IsExtreme`
subset, the paper's "convex linear subpolyhedron of `∂P`") whose image in
`ℝᵏ` is a polyhedron and lies in the *intrinsic* frontier of `P`. The
face condition is what the construction keeps invariant (`u (I × Q × X) ⊆
Q`); without it single interior points of `∂P` would qualify and condition
4 would vacuously force the homotopy to freeze them in time. -/
def IsBoundarySubpolyhedron {P : Set (Fin k → ℝ)} (Q : Set P) : Prop :=
  (∃ S : Finset (Fin k → ℝ),
      ((↑) : P → Fin k → ℝ) '' Q = convexHull ℝ (S : Set (Fin k → ℝ))) ∧
    ((↑) : P → Fin k → ℝ) '' Q ⊆ intrinsicFrontier ℝ P ∧
    IsExtreme ℝ P (((↑) : P → Fin k → ℝ) '' Q)





end FamiliesOfMapsB01
