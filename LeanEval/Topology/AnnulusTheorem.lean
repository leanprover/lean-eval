import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

open Metric (sphere)
open scoped unitInterval

/-!
# The Annulus Theorem (Kirby, n ≥ 5; Quinn, n = 4)

The annulus theorem states that the closed region between two disjoint, nested,
*locally flat* embedded `n`-spheres in `ℝⁿ⁺¹` is homeomorphic to the product
`Sⁿ × [0,1]`. Local flatness is essential — the Alexander horned sphere is a
(non locally flat) embedded `S²` in `ℝ³` for which the bounded complementary
region is not even simply connected, so the conclusion fails. The theorem was
the hard core of Kirby's work on the stable homeomorphism conjecture (dimension
`≥ 5`, 1969); the four-dimensional ambient case `n + 1 = 4` was settled by Quinn
(1982), building on Freedman.

We work with the unit sphere `Sⁿ ⊂ ℝⁿ⁺¹` as the source of the embeddings.

* **Local flatness** of an embedding `c : Sⁿ → ℝⁿ⁺¹` is encoded, as in
  `KnotTheory/Slice.lean`, by partial homeomorphisms of `ℝⁿ⁺¹`: near every image
  point there is an ambient chart carrying the image locally onto the model
  hyperplane `{x | xₙ = 0}`.
* **Inside.** Rather than invoke the Jordan–Brouwer separation theorem (which
  Mathlib does not have — it is itself an eval problem here), we *define* the
  inside of a set `S` to be the points whose connected component in the
  complement is bounded. For a locally flat sphere this is exactly the bounded
  complementary ball, but the definition is unconditional.

The closed region between an outer sphere `f` and a nested inner sphere `g` is
then `closure (inside (range f)) \ inside (range g)`: the closed ball bounded by
`f`, with the open ball bounded by `g` removed. The theorem says this region is
homeomorphic to `Sⁿ × [0,1]`.

Mathlib has `Homeomorph`, `OpenPartialHomeomorph`, spheres, and connected
components, but no Jordan–Brouwer/Schoenflies theorem, no notion of locally flat
embedding, and certainly nothing of Kirby's torus trick or Quinn's work.
-/

/-- Ambient Euclidean space `ℝⁿ⁺¹`. -/
abbrev Amb (n : ℕ) : Type := EuclideanSpace ℝ (Fin (n + 1))

/-- The unit `n`-sphere `Sⁿ ⊂ ℝⁿ⁺¹`. -/
abbrev Sph (n : ℕ) : Set (Amb n) := sphere (0 : Amb n) 1

/-- The model hyperplane `{x | xₙ = 0}` in `ℝⁿ⁺¹`, the local model for a flatly
embedded sphere. -/
def modelHyperplane (n : ℕ) : Set (Amb n) := {x | x (Fin.last n) = 0}

/-- An embedding `c : Sⁿ → ℝⁿ⁺¹` is **locally flat** if near every image point
there is an ambient partial homeomorphism of `ℝⁿ⁺¹` carrying the image of the
sphere locally onto the model hyperplane. -/
def LocallyFlat {n : ℕ} (c : Sph n → Amb n) : Prop :=
  ∀ p : Sph n, ∃ h : OpenPartialHomeomorph (Amb n) (Amb n),
    c p ∈ h.source ∧
    h.toFun '' (h.source ∩ Set.range c) = h.target ∩ modelHyperplane n

/-- A **locally flat embedded `n`-sphere** in `ℝⁿ⁺¹`: a continuous injective
locally flat map from the unit sphere. -/
structure FlatSphere (n : ℕ) where
  /-- The embedding. -/
  toFun : Sph n → Amb n
  /-- It is continuous. -/
  continuous : Continuous toFun
  /-- It is injective. -/
  injective : Function.Injective toFun
  /-- It is locally flat. -/
  flat : LocallyFlat toFun

/-- The **inside** of a set `S ⊆ ℝⁿ⁺¹`: the points of the complement whose
connected component there is bounded. For a locally flat sphere this is the open
ball it bounds. -/
def inside {n : ℕ} (S : Set (Amb n)) : Set (Amb n) :=
  {x | x ∉ S ∧ Bornology.IsBounded (connectedComponentIn Sᶜ x)}

/-- **The Annulus Theorem** (Kirby for ambient dimension `≥ 5`; Quinn for
ambient dimension `4`). Let `f` be a locally flat embedded `n`-sphere in `ℝⁿ⁺¹`
and `g` a second one nested strictly inside `f`: the two images are disjoint,
`g`'s image lies in the inside of `f`, and (a consequence of locally flat
nesting, stated explicitly for robustness) the inside of `g` is contained in the
inside of `f`. Then the closed region between them — the closed ball bounded by
`f` with the open ball bounded by `g` deleted — is homeomorphic to the product
`Sⁿ × [0,1]`. -/
@[eval_problem]
theorem annulus_theorem {n : ℕ}
    (f g : FlatSphere n)
    (hdisj : Disjoint (Set.range f.toFun) (Set.range g.toFun))
    (hnest : Set.range g.toFun ⊆ inside (Set.range f.toFun))
    (hinside : inside (Set.range g.toFun) ⊆ inside (Set.range f.toFun)) :
    Nonempty
      ((closure (inside (Set.range f.toFun)) \ inside (Set.range g.toFun) :
          Set (Amb n)) ≃ₜ (Sph n × I)) := by
  sorry

end Topology
end LeanEval
