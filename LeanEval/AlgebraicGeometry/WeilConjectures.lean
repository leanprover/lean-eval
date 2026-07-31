import Mathlib
import EvalTools.Markers

namespace LeanEval.AlgebraicGeometry.WeilConjectures

/-!
# Weil conjectures in terms of point counts

References:
* J.S. Milne. Lectures on Étale Cohomology. https://www.jmilne.org/math/CourseNotes/LEC.pdf
* E. Freitag, R. Kiehl. Étale cohomology and the Weil conjecture. 
* N. Katz. L-functions and monodromy: four lectures on Weil II.
  https://doi.org/10.1006/aima.2000.1979 or https://web.math.princeton.edu/~nmk/arizona34.pdf
* K. Kedlaya. Fourier transforms and p-adic "Weil II". https://arxiv.org/abs/math/0210149
-/

open CategoryTheory AlgebraicGeometry

/-- The structure morphism from a projective space `ℙⁿ_R` to `Spec R`. -/
noncomputable def Proj.strHom {R A : Type u} [CommRing R] [CommRing A] [Algebra R A]
    (𝒜 : ℕ → Submodule R A) [GradedAlgebra 𝒜] : Proj 𝒜 ⟶ Spec (.of R) :=
  Proj.toSpecZero 𝒜 ≫ Spec.map (CommRingCat.ofHom (algebraMap ..))

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The **Weil conjectures** in terms of point counts: if `X` is a smooth projective
algebraic variety (geometrically irreducible) over a finite field 𝔽ₚ (assumed to be
a prime field here for simplicity) of dimension `d`, then there exists multisets of
Frobenius eigenvalues (which are algebraic numbers) `Aᵢ` such that for every finite
extension `F / 𝔽ₚ` of degree `m`, we have `#X(F) = ∑_{0 ≤ i ≤ 2d} (-1)ⁱ ∑_{α ∈ Aᵢ} αᵐ`.
The multisets satisfy `A₀ = {1}`, Poincaré duality `A_{2d-i} = pᵈ / Aᵢ`, and
"Riemann hypothesis" `|α| = p^{i/2}` for all `α ∈ Aᵢ`. This statement does not include
the identity between sizes of the multisets and Betti numbers of a complex variety
defined over a number field whose reduction modulo `p` is `X`.

The Riemann hypothesis was first proved by Deligne while the rest were already established
by Grothendieck (with Artin, Verdier and earlier work of Dwork) using the theory of ℓ-adic
cohomology. -/
theorem weil_conjectures (n d p : ℕ) [Fact p.Prime] (X : Scheme)
    (emb : X ⟶ Proj (MvPolynomial.homogeneousSubmodule (Fin n) (ZMod p)))
    [IsClosedImmersion emb] [Smooth (emb ≫ Proj.strHom _)]
    (irred : geometrically (IrreducibleSpace ·) (emb ≫ Proj.strHom _))
    (dim : topologicalKrullDim X = d) :
    ∃ A : ℕ → Multiset ℂ, A 0 = {1} ∧
      (∀ i ≤ 2 * d, A (2 * d - i) = (A i).map (p ^ d / · : ℂ → ℂ)) ∧ 
      (∀ i ≤ 2 * d, ∀ α ∈ A i, IsAlgebraic ℚ α ∧ ‖α‖ = √(p ^ i)) ∧
      ∀ (F : Type) [Field F] [Algebra (ZMod p) F] [FiniteDimensional (ZMod p) F],
        Nat.card (Spec (.of F) ⟶ X) =
        ∑ i ∈ Finset.Iic (2 * d), (-1) ^ i * ((A i).map (· ^ Module.finrank (ZMod p) F)).sum := by
  sorry

end LeanEval.AlgebraicGeometry.WeilConjectures
