import LeanEval.KnotTheory.Prelude

namespace LeanEval
namespace KnotTheory

/-!
# Piecewise-linear knots and slice-ness

A parallel structure to the smooth `Knot` of `Prelude`. A `PLKnot` is an
embedded closed polyline in `ℝ³`, specified by a finite list of vertices.
The trade is: smoothness is gone (so we cannot apply the Mathlib smooth-map
infrastructure directly), but we can now write down a specific knot — like
the Conway knot — as a concrete `List R3`.

Slice-ness is defined image-based: a PL knot is *smoothly slice* (resp.
*topologically slice*) if the polyline's image in `ℝ³ = ℝ³ × {0}` is the
boundary of a smoothly (resp. topologically, locally flatly) embedded
2-disk in the upper half-space `ℝ³ × [0, ∞) ≃ B⁴ ∖ {pt}`.
-/

/-- Linear interpolation across the closed polyline with `vertices.length`
edges, each parametrized over unit time, extended periodically. Junk value
`0` on the empty list. -/
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
as one polyline, embedded (the polyline is a simple closed curve). -/
structure PLKnot where
  /-- The ordered list of polyline vertices. -/
  vertices : List R3
  /-- A closed polyline needs at least three vertices to be non-degenerate. -/
  three_le : 3 ≤ vertices.length
  /-- The polyline is a simple closed curve: viewed as a map
  `ℝ / vertices.length·ℤ → ℝ³`, it is injective. Equivalent to: all
  vertices distinct, non-adjacent edges disjoint, adjacent edges meet
  only at the shared vertex. -/
  isSimple : ∀ s t : ℝ,
    s ∈ Set.Ico (0 : ℝ) (vertices.length : ℝ) →
    t ∈ Set.Ico (0 : ℝ) (vertices.length : ℝ) →
    plCurve vertices s = plCurve vertices t →
    s = t

/-- The image of the PL knot in `ℝ³` (the trace of the polyline). -/
def PLKnot.image (K : PLKnot) : Set R3 :=
  plCurve K.vertices '' Set.Ico (0 : ℝ) (K.vertices.length : ℝ)

/-- The closed unit `2`-disk, the source of a slicing disk's parametrization. -/
abbrev disk2 : Set (ℝ × ℝ) := Metric.closedBall (0 : ℝ × ℝ) 1

/-- The unit circle in `ℝ²`, the source of the disk's boundary. -/
abbrev circle1 : Set (ℝ × ℝ) := Metric.sphere (0 : ℝ × ℝ) 1

/-- **Smoothly slice.** A PL knot is smoothly slice if its image bounds a
smoothly properly embedded 2-disk in the upper half-space `ℝ³ × [0, ∞)`:
there is a smooth `D : ℝ² → ℝ³ × ℝ` that is injective on the closed unit
2-disk, takes values in the closed half-space, sends the disk boundary
exactly to the half-space boundary, has injective differential everywhere
on the closed 2-disk, and projects the boundary circle onto the knot's
polyline image. -/
def PLKnot.SmoothlySlice (K : PLKnot) : Prop :=
  ∃ D : ℝ × ℝ → R3 × ℝ,
    ContDiff ℝ (⊤ : ℕ∞) D ∧
    Set.InjOn D disk2 ∧
    (∀ p ∈ disk2, 0 ≤ (D p).2) ∧
    (∀ p ∈ disk2, (D p).2 = 0 ↔ p ∈ circle1) ∧
    (∀ p ∈ disk2, Function.Injective (fderiv ℝ D p)) ∧
    (fun p => (D p).1) '' circle1 = K.image

/-- **Topologically slice.** A PL knot is topologically slice if its image
bounds a *locally flat* topologically embedded 2-disk in `ℝ³ × [0, ∞)`.

The locally flat clause is essential: without it, the cone over any knot
gives a topological disk (with a non-manifold cone point), so every knot
would trivially be topologically slice. We encode local flatness via the
existence of a self-homeomorphism of `ℝ³ × ℝ` that carries a neighborhood
of each disk point onto the model 2-plane

`{ q : R3 × ℝ | q.1 2 = 0 ∧ q.2 = 0 }`.

This is slightly stronger than the textbook "locally homeomorphic to
`(ℝ⁴, ℝ²)`" — the chart is a global homeomorphism of `ℝ³ × ℝ` rather
than a chart on a local neighborhood — but the two are mathematically
equivalent on a contractible ambient space. -/
def PLKnot.TopologicallySlice (K : PLKnot) : Prop :=
  ∃ D : ℝ × ℝ → R3 × ℝ,
    Continuous D ∧
    Set.InjOn D disk2 ∧
    (∀ p ∈ disk2, 0 ≤ (D p).2) ∧
    (∀ p ∈ disk2, (D p).2 = 0 ↔ p ∈ circle1) ∧
    (∀ p ∈ disk2,
      ∃ V : Set (R3 × ℝ), IsOpen V ∧ D p ∈ V ∧
        ∃ φ : (R3 × ℝ) ≃ₜ (R3 × ℝ),
          φ '' (V ∩ (D '' disk2)) =
            φ '' V ∩ { q : R3 × ℝ | q.1 2 = 0 ∧ q.2 = 0 }) ∧
    (fun p => (D p).1) '' circle1 = K.image

end KnotTheory
end LeanEval
