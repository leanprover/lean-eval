import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace RingTheory

/-!
# André's Existence of Balanced Big Cohen–Macaulay Algebras

Melvin Hochster conjectured in 1973 that every complete Noetherian local domain
$(R, \mathfrak{m})$ admits a (not necessarily finitely generated) commutative
$R$-algebra $B$ that is a *balanced big Cohen–Macaulay* $R$-algebra:
$\mathfrak{m} B \ne B$ and every system of parameters $x_1, \dots, x_d$ of $R$
forms a regular sequence on $B$.

Hochster (1975) and Hochster–Huneke (1992, *Ann. of Math.* 135) established the
theorem in equal characteristic, and Yves André (2018, *Publ. Math. Inst.
Hautes Études Sci.* 127, 71–93, Theorem 0.2; see also *J. Amer. Math. Soc.* 31,
2018) resolved the general mixed-characteristic case using perfectoid spaces
and his perfectoid Abhyankar lemma (implying in particular Hochster's direct
summand conjecture).

The statement uses zero custom definitions beyond Mathlib.
-/

/-- **Existence of balanced big Cohen–Macaulay algebras (Hochster–Huneke;
André 2018).** Every $\mathfrak{m}$-adically complete Noetherian local integral
domain $(R, \mathfrak{m})$ admits a commutative $R$-algebra $B$ such that
$\mathfrak{m} B \ne B$ and every system of parameters of $R$ (a list of length
$\dim R$ whose spanned ideal has radical $\mathfrak{m}$) is a $B$-regular
sequence. -/
@[eval_problem]
theorem andre_balanced_big_cohen_macaulay
    (R : Type) [CommRing R] [IsLocalRing R] [IsNoetherianRing R] [IsDomain R]
    [IsAdicComplete (IsLocalRing.maximalIdeal R) R] :
    ∃ (B : Type) (_ : CommRing B) (_ : Algebra R B),
      IsLocalRing.maximalIdeal R • (⊤ : Submodule R B) ≠ ⊤ ∧
      ∀ x : List R,
        (x.length : WithBot ℕ∞) = ringKrullDim R →
        (Ideal.span {r : R | r ∈ x}).radical = IsLocalRing.maximalIdeal R →
        RingTheory.Sequence.IsRegular B x := by
  sorry

end RingTheory
end LeanEval
