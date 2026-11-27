import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace AlgebraicGeometry

/-!
# Miyanishi's Kernel Theorem for Locally Nilpotent Derivations on $k[X_0, X_1, X_2]$

Masayoshi Miyanishi (1985, *Normal affine subalgebras of a polynomial ring*, in
*Algebraic and Topological Theories — to the memory of Dr. Takehiko Miyata*,
Kinokuniya, 37–51; combined with Tatsuji Kambayashi 1975, *J. Algebra* 35, 41–45,
to descend from $\overline{k}$ to arbitrary characteristic-zero ground fields;
see also Freudenburg, *Algebraic Theory of Locally Nilpotent Derivations*, 2nd
ed., Springer, 2017, Theorem 5.1) proved that for every field $k$ of
characteristic zero and every nonzero locally nilpotent $k$-derivation $D$ on
the polynomial ring $k[X_0, X_1, X_2]$, the kernel ring of invariants
$\ker D = \{p \in k[X_0, X_1, X_2] \mid D(p) = 0\}$ is isomorphic as a
$k$-algebra to the two-variable polynomial ring $k[Y_0, Y_1]$.
-/

/-- **Miyanishi's kernel theorem for locally nilpotent derivations on
$k[X_0, X_1, X_2]$.** Over any field $k$ of characteristic zero, if $D$ is a
nonzero locally nilpotent $k$-derivation on $k[X_0, X_1, X_2]$, then its kernel
is generated as a $k$-algebra by two algebraically independent polynomials
(equivalently, $\ker D \cong_k k[Y_0, Y_1]$). -/
@[eval_problem]
theorem miyanishi_lnd_kernel
    {k : Type} [Field k] [CharZero k]
    (D : Derivation k (MvPolynomial (Fin 3) k) (MvPolynomial (Fin 3) k))
    (hD_ne : D ≠ 0)
    (hD_nil : ∀ f : MvPolynomial (Fin 3) k, ∃ n : ℕ, (D^[n]) f = 0) :
    ∃ f g : MvPolynomial (Fin 3) k,
      AlgebraicIndependent k ![f, g] ∧
      (Algebra.adjoin k ({f, g} : Set (MvPolynomial (Fin 3) k)) :
        Set (MvPolynomial (Fin 3) k)) = {p | D p = 0} := by
  sorry

end AlgebraicGeometry
end LeanEval
