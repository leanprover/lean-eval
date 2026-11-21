import Mathlib.AlgebraicGeometry.EllipticCurve.LFunction
import TauCeti.NumberTheory.ModularForms.Newforms.Coefficient
import EvalTools.Markers

open UpperHalfPlane

namespace LeanEval
namespace NumberTheory

/-!
# The Modularity Theorem for Elliptic Curves over $\mathbb{Q}$

The Taniyama–Shimura–Weil modularity conjecture asserts that every elliptic
curve $E$ over $\mathbb{Q}$ is modular: there exist a positive integer level $N$
and a normalized weight-$2$ cuspidal newform $f \in S_2^{\mathrm{new}}(\Gamma_0(N))$
(i.e. on $\Gamma_1(N)$ with trivial nebentypus $\chi_f = 1$) whose $q$-expansion
coefficients at $\infty$ match the Dirichlet coefficients of the Hasse–Weil
$L$-function $L(E, s) = \sum_{n \ge 1} a_n(E) n^{-s}$ (computed at every prime
via a local minimal Weierstrass model).

Proved for semistable elliptic curves by Andrew Wiles (1995, *Ann. of Math.*
141, 443–551) and Richard Taylor and Andrew Wiles (1995, *Ann. of Math.* 141,
553–572), extended by Fred Diamond (1996) and Brian Conrad, Fred Diamond, and
Richard Taylor (1999), and proved in full generality (including the wildly
ramified $3$-adic cases) by Christophe Breuil, Brian Conrad, Fred Diamond, and
Richard Taylor (2001, *J. Amer. Math. Soc.* 14, 843–939).

The statement combines Mathlib's `WeierstrassCurve.LFunction` (defined via local
minimal models) with Tau Ceti's `HeckeRing.GL2.Newform`.
-/

/-- **The modularity theorem for elliptic curves over $\mathbb{Q}$
(Wiles; Taylor–Wiles; Breuil–Conrad–Diamond–Taylor 2001).** Every elliptic curve
$E$ over $\mathbb{Q}$ has Hasse–Weil $L$-function coefficients equal to the
$q$-expansion coefficients of a weight-$2$ cuspidal newform of some positive
level $N$ with trivial nebentypus. -/
@[eval_problem]
theorem elliptic_curve_modularity (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    ∃ (N : ℕ) (_ : NeZero N) (f : HeckeRing.GL2.Newform N 2),
      f.χ = 1 ∧
      ∀ n : ℕ, (qExpansion 1 f.toCuspForm).coeff n =
        (E.LFunction n : ℂ) := by
  sorry

end NumberTheory
end LeanEval
