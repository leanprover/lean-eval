import TauCeti.LowDimTopology.DehnSurgery.ZeroSurgeryGenus
import EvalTools.Markers

namespace LeanEval
namespace Topology

/-!
# Gabai's Theorem on the Genus of the Zero-Surgery

David Gabai (1987, *Foliations and the topology of $3$-manifolds. III*, *J.
Differential Geom.* 26, 479–536, Corollary 8.3; resolving Giffen's conjecture,
Kirby's Problem 1.41(B)) proved that for every smooth knot $K \subset S^3$, the
minimal genus of an embedded closed oriented surface representing a generator of
$H_2(S^3_0(K); \mathbb{Z})$ in the longitudinal $0$-surgery $S^3_0(K)$ equals
the Seifert genus $g(K)$ of $K$.

Stated using `TauCeti.GabaiZeroSurgeryGenusTheorem`.
-/

/-- **Gabai's zero-surgery genus theorem.** For every smooth knot $K$ in $S^3$,
every solid-torus tubular neighborhood $\Phi$ of $K$, and every longitudinal
$0$-surgery $Y$ along the preferred framing, every generator $c$ of
$H_2(Y; \mathbb{Z})$ has minimal genus equal to the Seifert genus of $K$. -/
@[eval_problem]
theorem gabai_zero_surgery_genus : TauCeti.GabaiZeroSurgeryGenusTheorem := by
  sorry

end Topology
end LeanEval
