import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace Analysis
namespace SobolevMorreyProblem

/-!
# Sobolev embedding theorem (Morrey regime)

When `n < p` and `r + α < k − n/p`, every `W^{k,p}(ℝⁿ)` function has a
`C^{r,α}` representative — the Sobolev embedding into Hölder spaces.
Charles Morrey, *Functions of several variables and absolute
continuity, II*, Duke Math. J. **6** (1940). The theorem is listed as
§111 in Knill's *Some Fundamental Theorems in Mathematics*.

The `LocallyIntegrable f` conjunct in `MemSobolevWk` is essential to
faithfulness: without it, a non-a.e.-measurable `f` would make every
distributional pairing `∫ f · D^m φ` collapse to the default value
that Lean's Bochner integral assigns outside integrability hypotheses,
so `IsWeakDeriv f 0 m` would hold vacuously and `f` would spuriously
satisfy `W^{k,p}` membership while having no a.e.-equal continuous
representative.

Mathlib has the subcritical Gagliardo–Nirenberg–Sobolev inequality
(`eLpNorm_le_eLpNorm_fderiv_*`) and the Bessel-potential / `H^{s,p}`
spaces (`TemperedDistribution.MemSobolev`), but no
weak-derivative Sobolev space `W^{k,p}` and no Morrey-regime embedding.
-/

open MeasureTheory
open scoped ENNReal NNReal

/-- The model space `ℝⁿ`. -/
abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- Classical partial derivative `∂_i φ` (directional derivative along
the `i`-th coordinate axis). -/
noncomputable def partialDeriv {n : ℕ} (i : Fin n) (φ : E n → ℝ) : E n → ℝ :=
  fun x => fderiv ℝ φ x (EuclideanSpace.single i (1 : ℝ))

/-- Classical mixed partial derivative `D^m φ` for a multi-index `m`. -/
noncomputable def mixedDeriv {n : ℕ} (m : Fin n → ℕ) (φ : E n → ℝ) : E n → ℝ :=
  (List.finRange n).foldr (fun i ψ => (partialDeriv i)^[m i] ψ) φ

/-- `g` is the **weak partial derivative** `D^m f` (multi-index `m`):
`∫ f · D^m φ = (−1)^{|m|} ∫ g · φ` for every smooth compactly supported
test function `φ`. -/
def IsWeakDeriv {n : ℕ} (f g : E n → ℝ) (m : Fin n → ℕ) : Prop :=
  ∀ φ : E n → ℝ, ContDiff ℝ (⊤ : ℕ∞) φ → HasCompactSupport φ →
    ∫ x, f x * mixedDeriv m φ x = (-1) ^ (∑ i, m i) * ∫ x, g x * φ x

/-- Membership in `W^{k,p}(ℝⁿ)`: locally integrable, and every weak
derivative `D^m f` of order `|m| ≤ k` exists and lies in `L^p`. -/
def MemSobolevWk {n : ℕ} (k : ℕ) (p : ℝ≥0∞) (f : E n → ℝ) : Prop :=
  LocallyIntegrable f volume ∧
  ∀ m : Fin n → ℕ, (∑ i, m i) ≤ k →
    ∃ g : E n → ℝ, IsWeakDeriv f g m ∧ MemLp g p volume

/-- Membership in `C^{r,α}(ℝⁿ)`: `r`-times continuously differentiable,
derivatives up to order `r` bounded, `r`-th derivative `α`-Hölder. -/
def MemHolder {n : ℕ} (r : ℕ) (α : ℝ) (g : E n → ℝ) : Prop :=
  ContDiff ℝ (r : ℕ∞) g ∧
  (∃ C : NNReal, HolderWith C α.toNNReal (iteratedFDeriv ℝ r g)) ∧
  (∀ j ≤ r, ∃ M : ℝ, ∀ x, ‖iteratedFDeriv ℝ j g x‖ ≤ M)

/-- **Sobolev embedding theorem (Morrey regime).** If `n < p`,
`0 < α ≤ 1` and `r + α < k − n/p`, then every `W^{k,p}(ℝⁿ)` function
has a `C^{r,α}` representative. -/
@[eval_problem]
theorem sobolev_embedding {n k r : ℕ} {α p : ℝ}
    (_hp : (n : ℝ) < p) (_hα : 0 < α) (_hα1 : α ≤ 1)
    (_hgap : (r : ℝ) + α < (k : ℝ) - n / p)
    (f : E n → ℝ) (_hf : MemSobolevWk k (ENNReal.ofReal p) f) :
    ∃ g : E n → ℝ, f =ᵐ[volume] g ∧ MemHolder r α g := by
  sorry

end SobolevMorreyProblem
end Analysis
end LeanEval
