import Mathlib
import EvalTools.Markers

/-!
# Schmidt's subspace theorem

https://en.wikipedia.org/wiki/Subspace_theorem

If L₁, …, Lₙ are ℂ-linearly independent linear forms in `n` variables with
algebraic coefficients and if ε>0 is any given real number, then the non-zero
integer points `x` with |L₁(x) … Lₙ(x)| < |x|^−ε lie in a finite number of proper
subspaces of ℚⁿ. The specialization n = 2 gives the Thue–Siegel–Roth theorem
(also in LeanEval as `thueSiegelRoth` and already solved on Jun 22, 2026).

## References

W.M. Schmidt, Diophantine approximation, Lecture Notes in Mathematics 785, Springer Verlag 1980, Chap. V,VI,VII.

The slides https://pub.math.leidenuniv.nl/~evertsejh/14-bonn.pdf present
Faltings’ product theorem, which gives a new proof and strong quantitative
versions of Schmidt’s subspace theorem.

https://pub.math.leidenuniv.nl/~evertsejh/dio19-7.pdf (course notes)
-/

namespace LeanEval.NumberTheory.SchmidtSubspace

/-- **Schmidt's subspace theorem**.

In our statement, we use an arbitrary Fintype σ with at least two elements instead of
`Fin n`, and use the fact that every proper subspace is contained in a codimension 1
subspace, which is described by the vanishing of a linear form with coefficients in ℤ. -/
@[eval_problem] theorem schmidt_subspace (σ : Type*) [Fintype σ] (hσ : 2 ≤ Fintype.card σ)
    (L : σ → σ → ℂ)
    (alg : ∀ i j, IsAlgebraic ℚ (L i j)) (ind : LinearIndependent ℂ L)
    (ε : ℝ) (pos : 0 < ε) :
    ∃ s : Finset (σ → ℤ), 0 ∉ s ∧ ∀ x : σ → ℤ,
      ‖∏ i, ∑ j, L i j * x j‖ < ‖x‖ ^ (-ε) → ∃ c ∈ s, ∑ i, c i * x i = 0 := by
  sorry

end LeanEval.NumberTheory.SchmidtSubspace
