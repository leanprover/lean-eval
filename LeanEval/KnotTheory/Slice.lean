import LeanEval.KnotTheory.Prelude

namespace LeanEval
namespace KnotTheory

/-!
# Slice-ness in the smooth `Knot` world, bridged to `PLKnot`

Slice-ness, both smooth and topological, lives most naturally on the smooth
`Knot` of `Prelude`: a smooth knot's image is a smooth `1`-submanifold of
`ℝ³`, so a smooth properly embedded `2`-disk whose smooth boundary lies on
the floor `ℝ³ × {0}` matches the knot image *as a set* without any corner
pathology.

For specific named knots, however, we prefer the PL world: a `PLKnot` is a
concrete `List R3` of polyline vertices, easy to write down for, e.g., the
Conway knot. To state Piccirillo's theorem about the *Conway knot type*, we
bridge: a PL knot is (smoothly / topologically) slice if it has a smooth
representative of the same knot type which is (smoothly / topologically)
slice in the standard smooth sense. "Same knot type" is encoded as
topological ambient isotopy of subsets of `ℝ³`; for tame knots — and PL
polylines are tame — this is classically equivalent to the smooth/PL knot
type relation.
-/

/-! ## Topological ambient isotopy of subsets of `ℝ³` -/

/-- A topological ambient isotopy of `ℝ³`: a one-parameter family of self-
homeomorphisms of `ℝ³`, jointly continuous in `(t, x)`, with a jointly
continuous inverse family, starting at the identity. The time domain is
`ℝ` for consistency with `AmbientIsotopy` in `Prelude.lean`; only `H 0`
and `H 1` matter for the isotopy relation. -/
structure TopAmbientIsotopy where
  /-- The forward family. -/
  H : ℝ → R3 → R3
  /-- The inverse family. -/
  Hinv : ℝ → R3 → R3
  /-- The forward family is jointly continuous in `(t, x)`. -/
  continuous : Continuous (Function.uncurry H)
  /-- The inverse family is jointly continuous in `(t, x)`. -/
  continuous_inv : Continuous (Function.uncurry Hinv)
  /-- `Hinv t` is a left inverse of `H t`. -/
  inv_left : ∀ t x, Hinv t (H t x) = x
  /-- `Hinv t` is a right inverse of `H t`. -/
  inv_right : ∀ t x, H t (Hinv t x) = x
  /-- The isotopy starts at the identity. -/
  start : H 0 = id

/-- Two subsets of `ℝ³` are *unoriented topologically ambient isotopic*
if some topological ambient isotopy of `ℝ³` carries one onto the other.
"Unoriented" because this is a set-level relation that forgets any
parametrization. -/
def Set.UnorientedTopAmbIsotopic (A B : Set R3) : Prop :=
  ∃ Φ : TopAmbientIsotopy, Φ.H 1 '' A = B

/-! ## The closed `2`-disk, unit circle, half-space, and model planes -/

/-- The closed unit `2`-disk, the source of a slicing disk's parametrization. -/
abbrev disk2 : Set (ℝ × ℝ) := Metric.closedBall (0 : ℝ × ℝ) 1

/-- The unit circle in `ℝ²`, the source of the slicing disk's boundary. -/
abbrev circle1 : Set (ℝ × ℝ) := Metric.sphere (0 : ℝ × ℝ) 1

/-- The closed upper half-space `ℝ³ × [0, ∞)` in `ℝ³ × ℝ`. We identify
`ℝ³ × [0, ∞)` with `B⁴ ∖ {pt}`, so slice disks live here. -/
def upperHalf : Set (R3 × ℝ) := { q | 0 ≤ q.2 }

/-- Model interior `2`-plane in `ℝ³ × ℝ`: the locus where the last two
coordinates of `q.1` and `q.2` all vanish. Used to express interior local
flatness of an embedded `2`-disk. -/
def modelPlane2 : Set (R3 × ℝ) := { q | q.1 1 = 0 ∧ q.1 2 = 0 }

/-- Model boundary half-plane in the upper half-space. The disk sits in
the plane `q.1 1 = 0 ∧ q.1 2 = 0` (a copy of `ℝ × ℝ`, parametrized by
`q.1 0` and `q.2`) and is restricted to the half-space `q.2 ≥ 0`. Used
to express boundary local flatness of a proper embedded disk. -/
def modelHalfPlane2 : Set (R3 × ℝ) := { q | q.1 1 = 0 ∧ q.1 2 = 0 ∧ 0 ≤ q.2 }

/-! ## Smooth slice-ness on a smooth `Knot`

A smooth knot `K` is smoothly slice if its image bounds a smooth properly
embedded `2`-disk in the upper half-space `ℝ³ × [0, ∞)`. Because `K`'s
image is a smooth `1`-submanifold, set-level boundary equality with the
disk's smooth boundary image works cleanly.
-/

/-- **Smoothly slice (smooth knot version).** -/
def Knot.SmoothlySlice (K : Knot) : Prop :=
  ∃ D : ℝ × ℝ → R3 × ℝ,
    ContDiff ℝ (⊤ : ℕ∞) D ∧
    Set.InjOn D disk2 ∧
    (∀ p ∈ disk2, 0 ≤ (D p).2) ∧
    (∀ p ∈ disk2, (D p).2 = 0 ↔ p ∈ circle1) ∧
    (∀ p ∈ disk2, Function.Injective (fderiv ℝ D p)) ∧
    (fun p => (D p).1) '' circle1 = Set.range K.curve

/-! ## Topological slice-ness on a smooth `Knot`

Topological sliceness requires a *locally flat* topological proper embedding
of the disk. Local flatness is encoded by `PartialHomeomorph` of `ℝ³ × ℝ`:
at every disk point, a partial homeomorphism whose source is an open
neighborhood of that point carries the disk image locally onto the model
`2`-plane (interior case) or model half-plane in the half-space (boundary
case). The boundary case is essential: a chart on all of `ℝ⁴` to a full
plane does not encode proper boundary behaviour at points where the disk
meets `ℝ³ × {0}`.
-/

/-- Local flatness of the disk image at an *interior* disk point `q`. -/
def IsLocallyFlatInterior (D : ℝ × ℝ → R3 × ℝ) (q : R3 × ℝ) : Prop :=
  ∃ h : OpenPartialHomeomorph (R3 × ℝ) (R3 × ℝ),
    q ∈ h.source ∧
    h.toFun '' (h.source ∩ D '' disk2) = h.target ∩ modelPlane2

/-- Local flatness of the disk image at a *boundary* disk point `q`. The
chart is ambient-open in `ℝ³ × ℝ` (it cannot be contained in the closed
half-space because `q.2 = 0` forces any open neighborhood of `q` to
escape the half-space), but it preserves the half-space and maps the
disk image onto the model half-plane in the half-space. -/
def IsLocallyFlatBoundary (D : ℝ × ℝ → R3 × ℝ) (q : R3 × ℝ) : Prop :=
  ∃ h : OpenPartialHomeomorph (R3 × ℝ) (R3 × ℝ),
    q ∈ h.source ∧
    h.toFun '' (h.source ∩ upperHalf) = h.target ∩ upperHalf ∧
    h.toFun '' (h.source ∩ D '' disk2) = h.target ∩ modelHalfPlane2

/-- **Topologically slice (smooth knot version).** A smooth knot is
topologically slice if its image bounds a *locally flat* topologically
embedded proper `2`-disk in the upper half-space, with interior and
boundary points using the matching local model. -/
def Knot.TopologicallySlice (K : Knot) : Prop :=
  ∃ D : ℝ × ℝ → R3 × ℝ,
    Continuous D ∧
    Set.InjOn D disk2 ∧
    (∀ p ∈ disk2, 0 ≤ (D p).2) ∧
    (∀ p ∈ disk2, (D p).2 = 0 ↔ p ∈ circle1) ∧
    (∀ p ∈ disk2 \ circle1, IsLocallyFlatInterior D (D p)) ∧
    (∀ p ∈ circle1, IsLocallyFlatBoundary D (D p)) ∧
    (fun p => (D p).1) '' circle1 = Set.range K.curve

/-! ## Piecewise-linear knots -/

/-- Linear interpolation across the closed polyline with `vertices.length`
edges, each parametrized over unit time, extended periodically. Junk
value `0` on the empty list. -/
noncomputable def plCurve (vertices : List R3) (t : ℝ) : R3 :=
  if h : vertices.length = 0 then 0
  else
    let n : ℕ := vertices.length
    let s : ℝ := t - (n : ℝ) * Int.floor (t / (n : ℝ))
    let k : ℕ := (Int.floor s).toNat
    let α : ℝ := s - k
    (1 - α) • vertices[k % n]'(Nat.mod_lt _ (Nat.pos_of_ne_zero h)) +
      α • vertices[(k + 1) % n]'(Nat.mod_lt _ (Nat.pos_of_ne_zero h))

/-- A piecewise-linear closed knot in `ℝ³`: at least three vertices, traced
as one polyline, embedded as a simple closed curve. -/
structure PLKnot where
  /-- The ordered list of polyline vertices. -/
  vertices : List R3
  /-- A closed polyline needs at least three vertices to be non-degenerate. -/
  three_le : 3 ≤ vertices.length
  /-- The polyline is a simple closed curve: injective on a half-open
  fundamental domain `[0, vertices.length)` for the periodic
  parametrization. Equivalent to: all vertices distinct, non-adjacent
  edges disjoint, adjacent edges meet only at the shared vertex. -/
  isSimple : ∀ s t : ℝ,
    s ∈ Set.Ico (0 : ℝ) (vertices.length : ℝ) →
    t ∈ Set.Ico (0 : ℝ) (vertices.length : ℝ) →
    plCurve vertices s = plCurve vertices t →
    s = t

/-- The image of the PL knot in `ℝ³` (the trace of the polyline). -/
def PLKnot.image (K : PLKnot) : Set R3 :=
  plCurve K.vertices '' Set.Ico (0 : ℝ) (K.vertices.length : ℝ)

/-! ## Bridge to smooth slice-ness via a smooth knot representative

The standard fact (PL = smooth = tame in dimension 3) underlies these
definitions: every PL knot has a smooth knot ambient-isotopic to it, and
the converse holds for tame smooth knots. We do not formalize that fact,
but our `PLKnot.SmoothlySlice` and `PLKnot.TopologicallySlice` admit
honest witnesses precisely when the PL polyline represents a slice
knot type in the standard sense.
-/

/-- A smooth knot `J` is a *smooth representative* of the PL knot `K` if
their images are unoriented topologically ambient isotopic in `ℝ³`. For
tame curves (which both sides are by construction) this is equivalent to
the usual smooth/PL knot type relation. -/
def PLKnot.HasSmoothRepresentative (K : PLKnot) (J : Knot) : Prop :=
  Set.UnorientedTopAmbIsotopic (Set.range J.curve) K.image

/-- **Smoothly slice (PL knot version).** A PL knot is smoothly slice if
some smooth knot of the same knot type is smoothly slice. This is
Piccirillo's theorem about the Conway knot in the form most natural for
a polyline witness. -/
def PLKnot.SmoothlySlice (K : PLKnot) : Prop :=
  ∃ J : Knot, K.HasSmoothRepresentative J ∧ J.SmoothlySlice

/-- **Topologically slice (PL knot version).** A PL knot is topologically
slice if some smooth knot of the same knot type is topologically slice. -/
def PLKnot.TopologicallySlice (K : PLKnot) : Prop :=
  ∃ J : Knot, K.HasSmoothRepresentative J ∧ J.TopologicallySlice

end KnotTheory
end LeanEval
