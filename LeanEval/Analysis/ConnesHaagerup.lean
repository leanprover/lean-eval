import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis

/-!
# Connes's Equivalence of Injectivity and Hyperfiniteness for Von Neumann Algebras

Let $M \subseteq \mathcal{B}(H)$ be a von Neumann algebra acting on a separable
complex Hilbert space $H$. Alain Connes (1976, *Ann. of Math.* 104, 73–115,
Theorem 6 and Corollary 7; Fields Medal 1982) proved that the following two
fundamental structural properties of $M$ are equivalent:

1. **Injectivity** (by Tomiyama's 1957 theorem, existence of a contractive
   linear projection $E : \mathcal{B}(H) \to \mathcal{B}(H)$ onto $M$, i.e.
   $\|E\| \le 1$, $E(\mathcal{B}(H)) \subseteq M$, and $E(x) = x$ for all
   $x \in M$, equivalently a conditional expectation from $\mathcal{B}(H)$ onto
   $M$);
2. **Approximate finite-dimensionality (hyperfiniteness)**: there exists an
   increasing sequence $F_0 \le F_1 \le \cdots$ of finite-dimensional unital
   $*$-subalgebras of $\mathcal{B}(H)$ generating $M$ as a von Neumann algebra,
   i.e., $(\bigcup_{n \in \mathbb{N}} F_n)'' = M$.

The statement uses only Mathlib's `VonNeumannAlgebra`, `StarSubalgebra`,
`ContinuousLinearMap`, and `TopologicalSpace.SeparableSpace`.
-/

/-- **Connes's theorem on injective von Neumann algebras.** A von Neumann
algebra $M \subseteq \mathcal{B}(H)$ on a separable complex Hilbert space $H$
admits a contractive linear projection from $\mathcal{B}(H)$ onto $M$ if and
only if it is generated (via the double commutant) by an increasing sequence of
finite-dimensional unital $*$-subalgebras of $\mathcal{B}(H)$. -/
@[eval_problem]
theorem connes_injective_iff_afd
    {H : Type} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [CompleteSpace H] [TopologicalSpace.SeparableSpace H]
    (M : VonNeumannAlgebra H) :
    (∃ E : (H →L[ℂ] H) →L[ℂ] (H →L[ℂ] H),
      ‖E‖ ≤ 1 ∧ (∀ T, E T ∈ M) ∧ ∀ x ∈ M, E x = x) ↔
    (∃ F : ℕ → StarSubalgebra ℂ (H →L[ℂ] H),
      Monotone F ∧
      (∀ n, FiniteDimensional ℂ (F n)) ∧
      Set.centralizer (Set.centralizer (⋃ n, (F n : Set (H →L[ℂ] H)))) =
        (M : Set (H →L[ℂ] H))) := by
  sorry

end Analysis
end LeanEval
