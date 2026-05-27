import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace AlgebraicGeometry

/-!
# Bézout's theorem with multiplicity (Étienne Bézout, 1779)

§50 of Knill's *Some Fundamental Theorems in Mathematics*. For `n`
homogeneous polynomials `f_1, …, f_n` of degrees `d_1, …, d_n ≥ 1` in
`n + 1` variables over an algebraically closed field, with finite common
projective zero set, the sum of intersection multiplicities at the
common zeros equals `∏ d_k`. Knill's example `x² − yz = 0`, `x² + z² −
yz = 0` has set-cardinality 1 (`[0 : 1 : 0]` only) but multiplicity 2,
so the literal "= d elements" reading is the with-multiplicity form.

## The intersection multiplicity

The problem ships a self-contained construction of the intersection
multiplicity at a projective point via the **affine cone** (Eisenbud,
*Commutative Algebra*, Chapter 12). For `p ∈ ℙⁿ` with rep `v ≠ 0`:

* `chartIndex p : Fin (n + 1)` is any index `i` with `v_i ≠ 0`
  (`Classical.choose` on `p.rep_nonzero`).
* `affineConeCoord p : Fin (n + 1) → K` is the unique line-of-`K · v`
  representative with `i`-th coordinate `1` (i.e. `q_j = v_j / v_i`).
* `maxIdealAt q` is the maximal ideal at `q ∈ 𝔸^{n+1}` — the kernel of
  `MvPolynomial.eval q : K[X_0, …, X_n] →+* K`, maximal by
  `RingHom.ker_isMaximal_of_surjective`.
* `localRingAt q := Localization.AtPrime (maxIdealAt q)`.
* `intersectionMultiplicity f p : ℕ∞ :=
    Module.length K (R_q ⧸ (f_1, …, f_n, X_i − 1))`.

The `X_i − 1` factor cuts the affine cone down to its transverse
hyperplane slice, recovering the projective intersection multiplicity.
`Module.length` (codomain `ℕ∞`) honestly reports `⊤` on
non-proper / positive-dimensional components; under the `_hfin`
hypothesis the quotient is finite-dimensional and the length is a
positive natural number.

## Mathlib status

`grep -ri bezout Mathlib/` returns only Bézout's *identity* for PIDs and
the `IsBezout` ring class. Mathlib has `Projectivization`,
`MvPolynomial.IsHomogeneous`, `Module.length`, `Module.length_eq_finrank`,
`Localization.AtPrime`, `IsLocalization.AtPrime.isLocalRing`, and
`IsAlgClosed.card_roots_eq_natDegree` (the `n = 1` base case), but no
projective Bézout theorem in any form, no intersection-multiplicity
construction, and no `vanishingSet` / dehomogenization API. Wiedijk-100
entry "Bézout's Theorem" (#60) refers to the integer gcd identity in HOL
Light / Isabelle / Lean / Agda-unimath, never the projective version.

The intended proof goes through Hilbert series, the Cohen–Macaulay
property of a regular sequence of homogeneous polynomials, and
multiplicativity of the degree under base change; alternatively via a
deformation argument to the generic case
`f_k = ∏_j (X_{k+1} − α_{k,j} · X_0)`.
-/

open scoped LinearAlgebra.Projectivization
open MvPolynomial

variable {K : Type*} [Field K]

/-- The projective space `ℙⁿ(K)`. -/
abbrev ProjSpace (K : Type*) [DivisionRing K] (n : ℕ) :=
  ℙ K (Fin (n + 1) → K)

/-- The projective vanishing set of a polynomial. -/
def vanishingSet {n : ℕ} (f : MvPolynomial (Fin (n + 1)) K) :
    Set (ProjSpace K n) :=
  {p | MvPolynomial.eval (Projectivization.rep p) f = 0}

/-- A chosen index `i : Fin (n+1)` with `p.rep i ≠ 0`. -/
noncomputable def chartIndex {n : ℕ} (p : ProjSpace K n) : Fin (n + 1) :=
  Classical.choose (Function.ne_iff.mp p.rep_nonzero)

lemma chartIndex_rep_ne_zero {n : ℕ} (p : ProjSpace K n) :
    Projectivization.rep p (chartIndex p) ≠ 0 :=
  Classical.choose_spec (Function.ne_iff.mp p.rep_nonzero)

/-- Affine cone coordinates of `p` on the chart `X_{chartIndex p} = 1`. -/
noncomputable def affineConeCoord {n : ℕ} (p : ProjSpace K n) :
    Fin (n + 1) → K :=
  fun j => Projectivization.rep p j / Projectivization.rep p (chartIndex p)

/-- Evaluation ring-hom `K[X_0, …, X_n] →+* K` sending `X_j ↦ q_j`. -/
noncomputable def evalAt {n : ℕ} (q : Fin (n + 1) → K) :
    MvPolynomial (Fin (n + 1)) K →+* K :=
  MvPolynomial.eval q

lemma evalAt_surjective {n : ℕ} (q : Fin (n + 1) → K) :
    Function.Surjective (evalAt q) := by
  intro k
  refine ⟨MvPolynomial.C k, ?_⟩
  simp [evalAt, MvPolynomial.eval_C]

/-- Maximal ideal of `K[X_0, …, X_n]` at the affine point `q`. -/
noncomputable def maxIdealAt {n : ℕ} (q : Fin (n + 1) → K) :
    Ideal (MvPolynomial (Fin (n + 1)) K) :=
  RingHom.ker (evalAt q)

instance maxIdealAt_isMaximal {n : ℕ} (q : Fin (n + 1) → K) :
    (maxIdealAt q).IsMaximal :=
  RingHom.ker_isMaximal_of_surjective _ (evalAt_surjective q)

instance maxIdealAt_isPrime {n : ℕ} (q : Fin (n + 1) → K) :
    (maxIdealAt q).IsPrime :=
  (maxIdealAt_isMaximal q).isPrime

/-- The local ring of `𝔸^{n+1}` at the affine point `q`. -/
noncomputable abbrev localRingAt {n : ℕ} (q : Fin (n + 1) → K) :=
  Localization.AtPrime (maxIdealAt q)

/-- Intersection multiplicity at a projective point of homogeneous
polynomials, via the affine-cone construction. -/
noncomputable def intersectionMultiplicity {n : ℕ}
    (f : Fin n → MvPolynomial (Fin (n + 1)) K)
    (p : ProjSpace K n) : ℕ∞ :=
  let q := affineConeCoord p
  let i := chartIndex p
  let φ : MvPolynomial (Fin (n + 1)) K →+* localRingAt q := algebraMap _ _
  let I : Ideal (localRingAt q) :=
    Ideal.span ((Set.range fun k : Fin n => φ (f k)) ∪ {φ (X i - C 1)})
  Module.length K (localRingAt q ⧸ I)

/-- **Bézout's theorem (with multiplicity).** Given `n` homogeneous
polynomials `f_k` in `n + 1` variables of degrees `d_k ≥ 1` over an
algebraically closed field with finite common projective zero set, the
sum of intersection multiplicities equals `∏ d_k`. -/
@[eval_problem]
theorem bezout_multiplicity [IsAlgClosed K] {n : ℕ}
    (f : Fin n → MvPolynomial (Fin (n + 1)) K)
    (d : Fin n → ℕ) (_hd : ∀ k, (f k).IsHomogeneous (d k))
    (_hd_pos : ∀ k, 1 ≤ d k)
    (_hfin : (⋂ k, vanishingSet (f k)).Finite) :
    ∑ᶠ p ∈ (⋂ k, vanishingSet (f k)), intersectionMultiplicity f p
      = (∏ k, d k : ℕ∞) := by
  sorry

end AlgebraicGeometry
end LeanEval
