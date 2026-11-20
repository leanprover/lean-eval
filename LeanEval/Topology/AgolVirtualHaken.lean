import TauCeti.Geometry.Manifold.Riemannian.Hyperbolic.VirtualHaken
import EvalTools.Markers

open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

/-!
# Agol's Virtual Haken Theorem

Friedhelm Waldhausen (1968, *Ann. of Math.* 87, 56–88; Kirby's Problem 3.2)
asked whether every closed aspherical $3$-manifold has a finite-sheeted Haken
cover. Ian Agol (2013, *Doc. Math.* 18, 1045–1087), building on Jeremy Kahn and
Vladimir Markovic's surface subgroup theorem (2012, *Ann. of Math.* 175,
1127–1190) and Daniel Wise's theory of special cube complexes and the malnormal
special quotient theorem, proved that every closed hyperbolic $3$-manifold is
virtually Haken.

The statement is `TauCeti.VirtualHakenConjecture.{0}` spelled out against Tau
Ceti's `IsHyperbolic` and `IsVirtuallyHaken`.
-/

/-- **Agol's virtual Haken theorem.** Every closed hyperbolic smooth
$3$-manifold admits a connected finite-sheeted Haken cover. -/
@[eval_problem]
theorem agol_virtual_haken
    (M : Type) [MetricSpace M] [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [IsManifold (𝓡 3) ∞ M] [CompactSpace M] [ConnectedSpace M]
    (hM : TauCeti.IsHyperbolic (I := 𝓡 3) (M := M)) :
    TauCeti.IsVirtuallyHaken M := by
  sorry

end Topology
end LeanEval
