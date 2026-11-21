import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace AlgebraicGeometry

/-!
# Affine Plane Cancellation (Two-Dimensional Zariski Cancellation)

The Zariski cancellation problem asks whether a commutative $k$-algebra $A$
satisfying $A[T_0, \dots, T_{m-1}] \cong_k k[X_0, \dots, X_{m+n-1}]$ must itself
be isomorphic to $k[X_0, \dots, X_{n-1}]$. In dimension $n = 2$ over an
algebraically closed field, this was proved in characteristic zero by Takao
Fujita (1979, *J. Fac. Sci. Univ. Tokyo* 26, 355–378) and Masayoshi Miyanishi and
Toru Sugie (1980, *Osaka J. Math.* 17, 339–362), and in positive characteristic
by K. Peter Russell (1981, *Math. Ann.* 255, 287–302). Combined with Tatsuji
Kambayashi's Galois descent theorem for separable forms of $\mathbb{A}^2$ (1975,
*J. Algebra* 35, 41–45), cancellation holds over every perfect field $k$.
-/

/-- **Fujita–Miyanishi–Sugie–Russell–Kambayashi affine plane cancellation
theorem.** Over any perfect field $k$, if a commutative $k$-algebra $A$
satisfies $A[T_0, \dots, T_{m-1}] \cong_k k[X_0, \dots, X_{m+1}]$ for some
$m \in \mathbb{N}$, then $A \cong_k k[X_0, X_1]$. -/
@[eval_problem]
theorem affine_plane_cancellation
    {k A : Type} [Field k] [PerfectField k] [CommRing A] [Algebra k A]
    (m : ℕ) (h : Nonempty (MvPolynomial (Fin m) A ≃ₐ[k] MvPolynomial (Fin (m + 2)) k)) :
    Nonempty (A ≃ₐ[k] MvPolynomial (Fin 2) k) := by
  sorry

end AlgebraicGeometry
end LeanEval
