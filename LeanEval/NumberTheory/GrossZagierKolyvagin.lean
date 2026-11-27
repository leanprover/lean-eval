import TauCeti.AlgebraicGeometry.EllipticCurve.BirchSwinnertonDyer.Statement
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# The Gross–Zagier–Kolyvagin Theorem (BSD in Analytic Rank at Most $1$)

Combining the modularity theorem for elliptic curves over $\mathbb{Q}$
(Wiles 1995; Taylor–Wiles 1995; Breuil–Conrad–Diamond–Taylor 2001), the
Gross–Zagier height formula for Heegner points on modular curves (1986,
*Invent. Math.* 84, 225–320), and Kolyvagin's Euler system of Heegner points
(1988, *Izv. Akad. Nauk SSSR Ser. Mat.* 52, 522–540; 1990, *The Grothendieck
Festschrift*, Vol. II, 435–483), together with the Bump–Friedberg–Hoffstein
(1990) and Murty–Murty (1991) nonvanishing theorem for quadratic twists, yields
the Birch–Swinnerton-Dyer rank conjecture and finiteness of the Tate–Shafarevich
group $\mathrm{Ш}(E/\mathbb{Q})$ for every elliptic curve $E/\mathbb{Q}$ whose
Hasse–Weil $L$-function has order of vanishing at most $1$ at $s = 1$.

The statement uses Tau Ceti's `LSeries.IsContinuationOn`, `E.LFunction`, and
`WeierstrassCurve.sha` from
`TauCeti.AlgebraicGeometry.EllipticCurve.BirchSwinnertonDyer.Statement`.
-/

/-- **Gross–Zagier–Kolyvagin theorem.** If $E$ is an elliptic curve over
$\mathbb{Q}$ and $F$ is an analytic continuation of its Hasse–Weil $L$-series to
a connected open set $U$ containing $1$ with $\operatorname{ord}_{s=1} F(s) \le 1$,
then the order of vanishing at $s = 1$ equals the Mordell–Weil rank of
$E(\mathbb{Q})$ and the Tate–Shafarevich group $\mathrm{Ш}(E/\mathbb{Q})$ is
finite. -/
@[eval_problem]
theorem gross_zagier_kolyvagin (E : WeierstrassCurve ℚ) [E.IsElliptic]
    {F : ℂ → ℂ} {U : Set ℂ}
    (hF : LSeries.IsContinuationOn ((↑) ∘ E.LFunction) F U) (h₁ : 1 ∈ U)
    (hord : analyticOrderAt F 1 ≤ 1) :
    analyticOrderAt F 1 = (Module.finrank ℤ E.toAffine.Point : ℕ∞) ∧ Finite E.sha := by
  sorry

end NumberTheory
end LeanEval
