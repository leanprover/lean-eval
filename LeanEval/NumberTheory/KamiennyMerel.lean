import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Kamienny–Merel Uniform Boundedness of Elliptic Curve Torsion

For every integer $d \ge 1$, there exists a uniform bound $B \in \mathbb{N}$
such that for every number field $K$ of degree $[K : \mathbb{Q}] \le d$ and
every elliptic curve $E$ over $K$, the torsion subgroup $E(K)_{\mathrm{tors}}$
is finite of cardinality at most $B$.

Proved by Loïc Merel (1996, *Invent. Math.* 124, 437–449), completing the
approach initiated by Barry Mazur (1977, for $d = 1$) and Sheldon Kamienny
(1992, *Invent. Math.* 109, 221–229, for $d = 2$).

Note that in Mathlib, `WeierstrassCurve.Affine.Point` represents the full group
$E(K)$ of $K$-rational points of the projective Weierstrass model (consisting of
the affine nonsingular points together with the identity point `0` at infinity).
The statement requires **zero new definitions** beyond Mathlib.
-/

/-- **Kamienny–Merel uniform torsion theorem.** For every integer $d \ge 1$,
there exists $B \in \mathbb{N}$ such that for every number field $K$ with
$[K : \mathbb{Q}] \le d$ and every elliptic curve $E$ over $K$, the set of
$K$-rational torsion points of $E$ is finite and has cardinality at most $B$. -/
@[eval_problem]
theorem kamienny_merel_uniform_torsion {d : ℕ} (hd : 1 ≤ d) :
    ∃ B : ℕ,
      ∀ (K : Type) [Field K] [DecidableEq K] [NumberField K],
        Module.finrank ℚ K ≤ d →
        ∀ (E : WeierstrassCurve K) [E.IsElliptic],
          Finite {P : E.toAffine.Point // IsOfFinAddOrder P} ∧
          Nat.card {P : E.toAffine.Point // IsOfFinAddOrder P} ≤ B := by
  sorry

end NumberTheory
end LeanEval
