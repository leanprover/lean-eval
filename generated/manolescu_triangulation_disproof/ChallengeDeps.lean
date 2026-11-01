import Mathlib

open Geometry

namespace LeanEval
namespace Topology

/-!
# Manolescu's disproof of the triangulation conjecture (2016)

The triangulation conjecture asked whether every topological manifold is
homeomorphic to a simplicial complex. Manolescu disproved it: in every dimension
`n ≥ 5` there are closed topological `n`-manifolds that are not triangulable. He
proved this by constructing a `Pin(2)`-equivariant Seiberg–Witten Floer homology
and using it to refute the existence of an element of the homology-cobordism
group of homology 3-spheres demanded by the Galewski–Stern / Matumoto reduction
of the triangulation problem.

We state the resolved theorem: for every `n ≥ 5` there is a closed `n`-manifold
that is not triangulable.

* A closed topological `n`-manifold is bundled as `ClosedTopManifold n`.
* **Triangulable** is encoded as being homeomorphic to the geometric realization
  of a *finite* simplicial complex — Mathlib's `SimplicialComplex ℝ E` with
  `K.faces` finite, whose `space` is the union of its faces, carrying the
  subspace topology from `E`. We let `E` range over the finite-dimensional
  Euclidean spaces `ℝᴺ`. This is faithful for a *closed* (compact) manifold: a
  triangulation of a compact space is a finite complex, which geometrically
  realizes in some `ℝᴺ`, and on a finite complex the ambient subspace topology of
  `ℝᴺ` (a normed space) is the honest polyhedron topology. The finiteness
  requirement is essential — without it the union-of-faces could be taken to be
  one singleton `0`-face per point of an embedded copy of `M`, whose `space` is
  just `M` again, which would make every manifold vacuously "triangulable".

Mathlib has `SimplicialComplex` and `ChartedSpace`, but no PL topology, no
manifold triangulation theory, no Seiberg–Witten / Floer homology, and nothing
of the Galewski–Stern obstruction — so neither the construction nor the
obstruction is anywhere in reach.
-/

/-- A closed connected topological `n`-manifold, bundled with its
topological-space and chart instances so its existence can be quantified over.
Charts model `carrier` on `EuclideanSpace ℝ (Fin n)` (the whole space), so it is
locally Euclidean with no boundary; with `CompactSpace` this is a closed
manifold. -/
structure ClosedTopManifold (n : ℕ) where
  /-- The underlying point set. -/
  carrier : Type
  [topology : TopologicalSpace carrier]
  [t2 : T2Space carrier]
  [secondCountable : SecondCountableTopology carrier]
  [charted : ChartedSpace (EuclideanSpace ℝ (Fin n)) carrier]
  [compact : CompactSpace carrier]
  [connected : ConnectedSpace carrier]

attribute [instance] ClosedTopManifold.topology ClosedTopManifold.t2
  ClosedTopManifold.secondCountable ClosedTopManifold.charted
  ClosedTopManifold.compact ClosedTopManifold.connected

/-- `M` is **triangulable**: it is homeomorphic to the geometric realization (the
union of the faces, with the subspace topology) of a *finite* simplicial complex
sitting in some finite-dimensional Euclidean space `ℝᴺ`. For a compact manifold
this is exactly the usual notion of triangulability; the finiteness of `K.faces`
is essential (see the module docstring). -/
def Triangulable {n : ℕ} (M : ClosedTopManifold n) : Prop :=
  ∃ (N : ℕ) (K : SimplicialComplex ℝ (EuclideanSpace ℝ (Fin N))),
    K.faces.Finite ∧ Nonempty (M.carrier ≃ₜ K.space)



end Topology
end LeanEval
