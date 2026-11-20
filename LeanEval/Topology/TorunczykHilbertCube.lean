import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Toruńczyk's Topological Characterization of the Hilbert Cube

Henryk Toruńczyk (1980, *On $\mathrm{CE}$-images of the Hilbert cube and
characterization of $Q$-manifolds*, *Fund. Math.* 106, 31–40, Theorem 1) proved
that a compact metric space $X$ is homeomorphic to the Hilbert cube
$Q = [0, 1]^{\mathbb{N}}$ if (and only if) $X$ is an absolute retract for
metrizable spaces and satisfies the disjoint-maps property: for every
$\varepsilon > 0$, any two continuous maps $f, g : Q \to X$ can be uniformly
$\varepsilon$-approximated by continuous maps $f', g' : Q \to X$ with disjoint
images.
-/

namespace TorunczykHilbertCube

/-- The Hilbert cube $Q = [0, 1]^{\mathbb{N}}$ with the product topology. -/
abbrev HilbertCube : Type := ℕ → Set.Icc (0 : ℝ) 1

/-- A topological space $X$ is an *absolute retract for metrizable spaces* if
$X$ is metrizable and every closed embedding of $X$ into a metrizable space $Z$
admits a continuous retraction $r : Z \to X$. -/
def IsAbsoluteRetract (X : Type) [TopologicalSpace X] : Prop :=
  TopologicalSpace.MetrizableSpace X ∧
    ∀ (Z : Type) [TopologicalSpace Z] [TopologicalSpace.MetrizableSpace Z] (e : X → Z),
      _root_.Topology.IsClosedEmbedding e → ∃ r : C(Z, X), ∀ x : X, r (e x) = x

/-- Toruńczyk's disjoint-maps property for a metric space $X$: for every
$\varepsilon > 0$, any two continuous maps $f, g : Q \to X$ can be uniformly
$\varepsilon$-approximated by continuous maps with disjoint ranges. -/
def HasDisjointCubeMaps (X : Type) [MetricSpace X] : Prop :=
  ∀ ε : ℝ, 0 < ε → ∀ f g : HilbertCube → X, Continuous f → Continuous g →
    ∃ f' g' : HilbertCube → X, Continuous f' ∧ Continuous g' ∧
      (∀ z, dist (f z) (f' z) < ε) ∧
      (∀ z, dist (g z) (g' z) < ε) ∧
      Disjoint (Set.range f') (Set.range g')

end TorunczykHilbertCube

/-- **Toruńczyk's characterization of the Hilbert cube.** Every compact metric
absolute retract with the disjoint Hilbert-cube maps property is homeomorphic
to the Hilbert cube $[0, 1]^{\mathbb{N}}$. -/
@[eval_problem]
theorem torunczyk_hilbert_cube (X : Type) [MetricSpace X] [CompactSpace X]
    (hAR : TorunczykHilbertCube.IsAbsoluteRetract X)
    (hdisj : TorunczykHilbertCube.HasDisjointCubeMaps X) :
    Nonempty (X ≃ₜ TorunczykHilbertCube.HilbertCube) := by
  sorry

end Topology
end LeanEval
