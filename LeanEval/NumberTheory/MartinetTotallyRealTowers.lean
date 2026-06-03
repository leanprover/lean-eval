import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Martinet's asymptotically-good totally real towers

`exists_totallyReal_discr_le` is Theorem 3.2 of

> T. F. Bloom, W. Sawin, C. Schildkraut, D. Zhelezov,
> *The sum-product conjecture is false for real numbers*, `arXiv:2605.28781`,

which is the sole classical input their formalization takes as an axiom (see
`SumProduct.exists_totallyReal_discr_le` in
<https://github.com/mathlib-initiative/sum_product>). The underlying result is
Martinet's construction (1978) of asymptotically-good totally real towers — a
family of totally real number fields of growing degree with bounded root
discriminant — obtained from class field theory (Golod–Shafarevich towers).
It is not currently available in Mathlib.

A bounded root discriminant `rd_K = |Δ_K|^{1/d} ≤ C` is exactly the statement
that `|Δ_K| ≤ C ^ d`, so the bound below captures Martinet's theorem in the
form used by the sum-product argument. "Infinitely many degrees `d`" is the
cofinal form `∀ N, ∃ d ≥ N`.
-/

open NumberField

/-- **Theorem 3.2 (Martinet).**

There is an absolute constant `C > 0` such that for infinitely many degrees `d`
there is a totally real number field `K` of degree `d` over `ℚ` whose
discriminant satisfies `|Δ_K| ≤ C ^ d`.

"Infinitely many `d`" is expressed as: for every `N` there is a degree `d ≥ N`
that works. -/
@[eval_problem]
theorem exists_totallyReal_discr_le :
    ∃ C : ℝ, 0 < C ∧ ∀ N : ℕ, ∃ d : ℕ, N ≤ d ∧
      ∃ (K : Type) (_ : Field K) (_ : NumberField K) (_ : NumberField.IsTotallyReal K),
        Module.finrank ℚ K = d ∧ |(NumberField.discr K : ℝ)| ≤ C ^ d := by
  sorry

end NumberTheory
end LeanEval
