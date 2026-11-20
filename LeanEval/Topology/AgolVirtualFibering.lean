import TauCeti.Geometry.Manifold.Riemannian.Hyperbolic.VirtualFibering
import EvalTools.Markers

open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

/-!
# Agol's Virtual Fibering Theorem

William Thurston (1982, *Bull. Amer. Math. Soc.* (N.S.) 6, 357–381, Problem 18)
asked whether every closed hyperbolic $3$-manifold admits a finite-sheeted
covering space that fibers over the circle $S^1$. Ian Agol (2013, *Doc. Math.*
18, 1045–1087), combining his RFRS virtual fibering criterion (2008, *J. Topol.*
1, 269–284) with Kahn–Markovic (2012), Haglund–Wise special cube complexes, and
his proof of Wise's malnormal special quotient conjecture, resolved Thurston's
virtual fibering question in the affirmative.

The statement is `TauCeti.VirtualFiberingConjecture.{0}` spelled out against
Tau Ceti's `IsHyperbolic` and `IsVirtuallyFibered`.
-/

/-- **Agol's virtual fibering theorem.** Every closed hyperbolic smooth
$3$-manifold admits a connected finite-sheeted covering space that fibers over
the circle $S^1$. -/
@[eval_problem]
theorem agol_virtual_fibering
    (M : Type) [MetricSpace M] [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [IsManifold (𝓡 3) ∞ M] [CompactSpace M] [ConnectedSpace M]
    (hM : TauCeti.IsHyperbolic (I := 𝓡 3) (M := M)) :
    TauCeti.IsVirtuallyFibered M := by
  sorry

end Topology
end LeanEval
