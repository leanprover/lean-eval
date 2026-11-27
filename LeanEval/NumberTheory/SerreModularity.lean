import Mathlib.FieldTheory.Galois.Infinite
import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.RingTheory.Frobenius
import Mathlib.RingTheory.Unramified.Locus
import TauCeti.NumberTheory.ModularForms.Newforms.Fields
import EvalTools.Markers

open UpperHalfPlane
open scoped MatrixGroups

namespace LeanEval
namespace NumberTheory

/-!
# Serre's Modularity Conjecture (Khare–Wintenberger Theorem)

Jean-Pierre Serre conjectured (1973; refined 1987, *Duke Math. J.* 54,
179–230) that every continuous, odd, absolutely irreducible two-dimensional
mod-$p$ representation
$$
  \bar\rho : \mathrm{Gal}(\overline{\mathbb{Q}} / \mathbb{Q}) \longrightarrow
    \mathrm{GL}_2(k)
$$
over a finite field $k$ of prime characteristic $p$ arises from a normalized
cuspidal newform $f = \sum_{n \ge 1} a_n q^n \in S_w(\Gamma_1(N), \chi_f)$ of
some level $N \ge 1$ coprime to $p$ and weight $w \ge 2$: for some ring
homomorphism $\lambda : \mathcal{O}_{K_f} \to \overline{k}$ (reducing modulo a
prime above $p$ of the ring of integers of the coefficient field $K_f$), at
every rational prime $\ell \nmid p N$ the representation $\bar\rho$ is
unramified at $\ell$ and every arithmetic Frobenius element $\mathrm{Frob}_\ell$
satisfies
$$
  \mathrm{tr}\,\bar\rho(\mathrm{Frob}_\ell) = \lambda(a_\ell), \qquad
  \det \bar\rho(\mathrm{Frob}_\ell) = \lambda(\chi_f(\ell)) \cdot \ell^{w - 1}.
$$

Proved in full generality (for all primes $p$, levels, and weights) by
Chandrashekhar Khare and Jean-Pierre Wintenberger (2009, *Invent. Math.* 178,
485–504 and 505–586), with the final $2$-adic deformation-ring ingredient
established by Mark Kisin (2009, *Invent. Math.* 178, 587–634).

Stated against Mathlib's Galois theory and arithmetic Frobenius (`IsArithFrobAt`)
and Tau Ceti's `HeckeRing.GL2.Newform` and `TauCeti.CoefficientField`.
-/

/-- **Serre's modularity conjecture (Khare–Wintenberger 2009; Kisin 2009).**
Every continuous, odd, absolutely irreducible two-dimensional representation
$\rho : \mathrm{Gal}(\overline{\mathbb{Q}}/\mathbb{Q}) \to \mathrm{GL}_2(k)$
over a finite field $k$ of prime characteristic $p$ arises (modulo a prime of
$\mathcal{O}_{K_f}$) from a normalized cuspidal newform $f$ of some positive
level $N$ coprime to $p$ and weight $w \ge 2$. -/
@[eval_problem]
theorem serre_modularity
    {p : ℕ} (hp : p.Prime) {k : Type} [Field k] [Finite k] [CharP k p]
    (ρ : (AlgebraicClosure ℚ ≃ₐ[ℚ] AlgebraicClosure ℚ) →* GL (Fin 2) k)
    (hcont : IsOpen (ρ.ker : Set (AlgebraicClosure ℚ ≃ₐ[ℚ] AlgebraicClosure ℚ)))
    (hodd : ∀ c : AlgebraicClosure ℚ ≃ₐ[ℚ] AlgebraicClosure ℚ,
      c ≠ 1 → c * c = 1 → Matrix.det (ρ c : Matrix (Fin 2) (Fin 2) k) = -1)
    (hirr : ¬ ∃ v : Fin 2 → AlgebraicClosure k, v ≠ 0 ∧
      ∀ σ : AlgebraicClosure ℚ ≃ₐ[ℚ] AlgebraicClosure ℚ, ∃ a : AlgebraicClosure k,
        Matrix.mulVec ((ρ σ : Matrix (Fin 2) (Fin 2) k).map
          (algebraMap k (AlgebraicClosure k))) v = a • v) :
    ∃ (L : IntermediateField ℚ (AlgebraicClosure ℚ)) (_ : FiniteDimensional ℚ L)
      (_ : IsGalois ℚ L) (ρL : (L ≃ₐ[ℚ] L) →* GL (Fin 2) k),
      (∀ σ : AlgebraicClosure ℚ ≃ₐ[ℚ] AlgebraicClosure ℚ,
        ρ σ = ρL (AlgEquiv.restrictNormal σ L)) ∧
      ∃ (N : ℕ) (_ : NeZero N) (_ : p.Coprime N) (w : ℕ) (_ : 2 ≤ w)
        (f : HeckeRing.GL2.Newform N (w : ℤ))
        (lam : NumberField.RingOfIntegers (TauCeti.CoefficientField f) →+*
          AlgebraicClosure k),
        ∀ (ℓ : ℕ), ℓ.Prime → (hℓpN : ℓ.Coprime (p * N)) →
          ∃ (aℓ cℓ : NumberField.RingOfIntegers (TauCeti.CoefficientField f)),
            ((aℓ : TauCeti.CoefficientField f) : ℂ) = (qExpansion 1 f.toCuspForm).coeff ℓ ∧
            ((cℓ : TauCeti.CoefficientField f) : ℂ) =
              (f.χ (ZMod.unitOfCoprime ℓ
                (hℓpN.coprime_dvd_right (dvd_mul_left N p))) : ℂ) ∧
            ∀ (Q : Ideal (NumberField.RingOfIntegers L)) [Q.IsPrime]
              [Q.LiesOver (Ideal.span {(ℓ : ℤ)})],
              Algebra.IsUnramifiedAt ℤ Q ∧
              ∀ σ : L ≃ₐ[ℚ] L, IsArithFrobAt ℤ σ Q →
                algebraMap k (AlgebraicClosure k)
                  (Matrix.trace (ρL σ : Matrix (Fin 2) (Fin 2) k)) = lam aℓ ∧
                algebraMap k (AlgebraicClosure k)
                  (Matrix.det (ρL σ : Matrix (Fin 2) (Fin 2) k)) =
                    lam cℓ * (ℓ : AlgebraicClosure k) ^ (w - 1) := by
  sorry

end NumberTheory
end LeanEval
