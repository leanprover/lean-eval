import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

open Matrix

/-!
# A 3-manifold group with no faithful representation into GL(4, ℝ) (Button)

`[Kir97, Problem 3.33]`, due to W. Thurston, asks whether every finitely
generated 3-manifold group admits a faithful (injective) representation into
`GL(4, ℝ)`. This is true for hyperbolic 3-manifolds, but Button gave a negative
answer in general: the fundamental groups of certain closed graph manifolds
admit no faithful representation into `GL(4, k)` for *any* field `k` (J. O.
Button, *Aspherical 3-manifold groups not in `GL(4, k)`*, 2014).

We state the negative answer to Thurston's question over `ℝ`: there is a closed
connected 3-manifold whose fundamental group has no faithful representation into
`GL(4, ℝ)`. (Button's theorem is in fact stronger, ruling out every field.)

A closed connected topological 3-manifold is bundled as `Closed3Manifold`. The
statement is not vacuous: a simply connected witness would have trivial `π₁`,
whose unique map to `GL(4, ℝ)` is injective, contradicting the universal
non-injectivity — so the witness must genuinely have a non-linear fundamental
group.

Mathlib has `FundamentalGroup`, `GL`, `MonoidHom`, and `ChartedSpace`, but no
graph manifolds and none of the linearity obstructions (residual properties,
the structure theory of 3-manifold groups) Button's argument relies on.
-/

/-- A closed connected topological 3-manifold, bundled with its topological-space
and chart instances so its existence can be quantified over. Charts model
`carrier` on `EuclideanSpace ℝ (Fin 3)` (the whole space), so it is locally
Euclidean with no boundary; with `CompactSpace` this is a closed manifold. -/
structure Closed3Manifold where
  /-- The underlying point set. -/
  carrier : Type
  [topology : TopologicalSpace carrier]
  [t2 : T2Space carrier]
  [secondCountable : SecondCountableTopology carrier]
  [charted : ChartedSpace (EuclideanSpace ℝ (Fin 3)) carrier]
  [compact : CompactSpace carrier]
  [connected : ConnectedSpace carrier]

attribute [instance] Closed3Manifold.topology Closed3Manifold.t2
  Closed3Manifold.secondCountable Closed3Manifold.charted Closed3Manifold.compact
  Closed3Manifold.connected

/-- **A non-linear 3-manifold group** (Button, answering `[Kir97, Problem 3.33]`
negatively). There is a closed connected topological 3-manifold `M` and a
basepoint `x` such that the fundamental group `π₁(M, x)` admits no faithful
(injective) representation into `GL(4, ℝ)`. -/
@[eval_problem]
theorem nonlinear_three_manifold_group :
    ∃ (M : Closed3Manifold) (x : M.carrier),
      ∀ f : FundamentalGroup M.carrier x →* GL (Fin 4) ℝ, ¬ Function.Injective f := by
  sorry

end Topology
end LeanEval
