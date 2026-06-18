import Mathlib

namespace LeanEval
namespace Topology

open CategoryTheory AlgebraicTopology
open Metric (sphere)

/-!
# Existence of an aspherical integer homology 4-sphere (Tschantz)

`[Kir97, Problem 4.17]` asks whether there is a closed aspherical 4-manifold
that is an integer homology 4-sphere. Ratcliffe–Tschantz answered this
affirmatively (S. Tschantz; see J. Ratcliffe, S. Tschantz, *On the
Davis hyperbolic 4-manifold*, 2005); their examples even admit metrics of
non-positive curvature. (Earlier, Luo constructed an aspherical *rational*
homology 4-sphere.)

We state the existence of such a manifold. A closed topological 4-manifold is
bundled as `Closed4Manifold` so that we can quantify over its existence
together with its topological-space and chart data. The two conditions are:

* **aspherical** — every higher homotopy group `πₖ` (`k ≥ 2`) vanishes, at every
  basepoint. For a connected closed manifold (a CW complex) this is exactly the
  statement that the universal cover is contractible, i.e. that the manifold is a
  `K(π, 1)`.
* **integer homology 4-sphere** — the singular homology with `ℤ` coefficients
  agrees, in every degree, with that of the standard 4-sphere `S⁴`. (This forces
  `H₀ ≅ ℤ`, hence connectedness, `H₄ ≅ ℤ`, and `Hₖ = 0` otherwise.)

Mathlib has `HomotopyGroup`, singular homology (`singularHomologyFunctor`),
`ChartedSpace`, and the sphere as a topological space, but no aspherical
4-manifolds, no hyperbolic geometry in this range, and nothing resembling the
Davis/Tschantz construction.
-/

/-- A closed connected topological 4-manifold, bundled with its topological-space
and chart instances so its existence can be quantified over. Charts model
`carrier` on `EuclideanSpace ℝ (Fin 4)` (the whole space, not a half-space), so
the space is locally Euclidean with no boundary; together with `CompactSpace`
this is a closed manifold. This is the charted topological-manifold model — it
carries `ChartedSpace`, not Mathlib's stronger bundled `IsManifold` class, which
is exactly right for a topological (not necessarily smooth) manifold. -/
structure Closed4Manifold where
  /-- The underlying point set. -/
  carrier : Type
  [topology : TopologicalSpace carrier]
  [t2 : T2Space carrier]
  [secondCountable : SecondCountableTopology carrier]
  [charted : ChartedSpace (EuclideanSpace ℝ (Fin 4)) carrier]
  [compact : CompactSpace carrier]
  [connected : ConnectedSpace carrier]

attribute [instance] Closed4Manifold.topology Closed4Manifold.t2
  Closed4Manifold.secondCountable Closed4Manifold.charted Closed4Manifold.compact
  Closed4Manifold.connected

/-- `Hₖ(X; ℤ)`, the `k`-th singular homology with integer coefficients, as an
object of `ModuleCat ℤ`. -/
noncomputable def intHomology (k : ℕ) (X : TopCat) : ModuleCat ℤ :=
  ((singularHomologyFunctor (ModuleCat ℤ) k).obj (ModuleCat.of ℤ ℤ)).obj X

/-- `M` is **aspherical**: every higher homotopy group vanishes at every
basepoint. -/
def Closed4Manifold.IsAspherical (M : Closed4Manifold) : Prop :=
  ∀ k : ℕ, 2 ≤ k → ∀ x : M.carrier, Subsingleton (HomotopyGroup (Fin k) M.carrier x)

/-- `M` is an **integer homology 4-sphere**: in every degree its integral
singular homology is isomorphic to that of the standard 4-sphere. -/
def Closed4Manifold.IsIntegerHomologySphere (M : Closed4Manifold) : Prop :=
  ∀ k : ℕ, Nonempty (intHomology k (TopCat.of M.carrier) ≅
    intHomology k (TopCat.of (sphere (0 : EuclideanSpace ℝ (Fin 5)) 1)))



end Topology
end LeanEval
