import TauCeti.LowDimTopology.Geometrization
import EvalTools.Markers

open scoped ContDiff Manifold

namespace LeanEval
namespace Topology

/-!
# Perelman's Proof of Thurston's Geometrization Conjecture

William Thurston conjectured (1982, *Bull. Amer. Math. Soc.* (N.S.) 6, 357–381;
Kirby's Problem 3.45), and Grigori Perelman proved via Ricci flow with surgery
(2002–2003, arXiv:math/0211159, arXiv:math/0303109, arXiv:math/0307245; see also
Kleiner–Lott 2008, *Geom. Topol.* 12, and Morgan–Tian 2014, *Clay Math.
Monogr.* 5), that every closed orientable irreducible smooth $3$-manifold admits
a finite family of pairwise disjoint, locally flat, incompressible embedded tori
cutting it into connected components each of which is either Seifert-fibred or
admits a complete finite-volume hyperbolic metric.

The statement is `TauCeti.GeometrizationConjecture.{0}` spelled out against the
Tau Ceti definitions `TauCeti.IsSphereBoundsBall` and
`TauCeti.IsGeometricTorusDecomposition`.
-/

/-- **Perelman's geometrization theorem (Thurston's geometrization conjecture).**
Every closed orientable irreducible smooth $3$-manifold admits a finite
decomposition along pairwise disjoint locally flat incompressible tori into
Seifert-fibred and finite-volume hyperbolic pieces. -/
@[eval_problem]
theorem perelman_geometrization
    (M : Type) [MetricSpace M] [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [IsManifold (𝓡 3) ∞ M] [CompactSpace M] [ConnectedSpace M]
    [TauCeti.Orientable (𝓡 3) M] (hM : TauCeti.IsSphereBoundsBall M) :
    ∃ (n : ℕ) (T : Fin n → C(Circle × Circle, M)),
      TauCeti.IsGeometricTorusDecomposition T := by
  sorry

end Topology
end LeanEval
