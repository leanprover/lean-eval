import Mathlib

namespace LeanEval
namespace Topology

open Metric (sphere)

/-!
# Shared infrastructure for the Annulus Theorem eval problems

The annulus theorem states that the closed region between two disjoint, nested,
*locally flat* embedded `(n-1)`-spheres in `ℝⁿ` is homeomorphic to `Sⁿ⁻¹ × [0,1]`.
Local flatness is essential — the Alexander horned sphere is a (non locally flat)
embedded `S²` in `ℝ³` for which the bounded complementary region is not even
simply connected, so the conclusion fails.

This module collects the definitions shared by the two eval problems for the
theorem, which live in separate modules because their two dimension regimes are
of entirely different difficulty:

* `AnnulusTheoremHighDim` — Kirby (1969), ambient dimension `n ≥ 5`, via the
  stable homeomorphism conjecture and the torus trick;
* `AnnulusTheoremDimFour` — Quinn (1982), ambient dimension `n = 4`, building on
  Freedman's topology of 4-manifolds.

(Low dimensions `n ≤ 3` are classical, by Radó and Moise, and are not stated.)
Keeping the problems in separate files means a solver can attempt Kirby's case
without Quinn's `4`-dimensional theorem appearing in the workspace at all.

* **Local flatness** of an embedding `c : Sⁿ⁻¹ → ℝⁿ` is encoded, as in
  `KnotTheory/Slice.lean`, by partial homeomorphisms of `ℝⁿ`: near every image
  point there is an ambient chart carrying the image locally onto the model
  hyperplane `{x | x₀ = 0}`.
* **Inside.** Rather than invoke the Jordan–Brouwer separation theorem (which
  Mathlib does not have — it is itself an eval problem here), we *define* the
  inside of a set `S` to be the points whose connected component in the
  complement is bounded. For a locally flat sphere this is exactly the bounded
  complementary ball, but the definition is unconditional.

The closed region between an outer sphere `f` and a nested inner sphere `g` is
`closure (inside (range f)) \ inside (range g)`: the closed ball bounded by `f`,
with the open ball bounded by `g` removed. For locally flat nested spheres the
inside of `g` is automatically contained in the inside of `f` (generalized
Schoenflies), so this is the genuine annular shell; it is not assumed.

Mathlib has `Homeomorph`, `OpenPartialHomeomorph`, spheres, and connected
components, but no Jordan–Brouwer/Schoenflies theorem, no notion of locally flat
embedding, and nothing of Kirby's torus trick or Quinn's 4-dimensional work.
-/

/-- Ambient Euclidean space `ℝⁿ`. -/
abbrev Amb (n : ℕ) : Type := EuclideanSpace ℝ (Fin n)

/-- The unit `(n-1)`-sphere `Sⁿ⁻¹ ⊂ ℝⁿ`. -/
abbrev Sph (n : ℕ) : Set (Amb n) := sphere (0 : Amb n) 1

/-- The model hyperplane `{x | x₀ = 0}` in `ℝⁿ`, the local model for a flatly
embedded sphere. -/
def modelHyperplane (n : ℕ) [NeZero n] : Set (Amb n) := {x | x 0 = 0}

/-- An embedding `c : Sⁿ⁻¹ → ℝⁿ` is **locally flat** if near every image point
there is an ambient partial homeomorphism of `ℝⁿ` carrying the image of the
sphere locally onto the model hyperplane. -/
def LocallyFlat {n : ℕ} [NeZero n] (c : Sph n → Amb n) : Prop :=
  ∀ p : Sph n, ∃ h : OpenPartialHomeomorph (Amb n) (Amb n),
    c p ∈ h.source ∧
    h.toFun '' (h.source ∩ Set.range c) = h.target ∩ modelHyperplane n

/-- A **locally flat embedded `(n-1)`-sphere** in `ℝⁿ`: a continuous injective
locally flat map from the unit sphere. -/
structure FlatSphere (n : ℕ) [NeZero n] where
  /-- The embedding. -/
  toFun : Sph n → Amb n
  /-- It is continuous. -/
  continuous : Continuous toFun
  /-- It is injective. -/
  injective : Function.Injective toFun
  /-- It is locally flat. -/
  flat : LocallyFlat toFun

/-- The **inside** of a set `S ⊆ ℝⁿ`: the points of the complement whose
connected component there is bounded. For a locally flat sphere this is the open
ball it bounds. -/
def inside {n : ℕ} (S : Set (Amb n)) : Set (Amb n) :=
  {x | x ∉ S ∧ Bornology.IsBounded (connectedComponentIn Sᶜ x)}

/-- The closed region between an outer flat sphere `f` and an inner flat sphere
`g`: the closed ball bounded by `f` with the open ball bounded by `g` removed. -/
def regionBetween {n : ℕ} [NeZero n] (f g : FlatSphere n) : Set (Amb n) :=
  closure (inside (Set.range f.toFun)) \ inside (Set.range g.toFun)

end Topology
end LeanEval
