import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace NumberTheory

/-!
# Goldfeld–Gross–Zagier–Oesterlé Effective Lower Bound on Imaginary Quadratic Class Numbers

Gauss's class number problem asks for an effective lower bound on the class
number $h(K)$ of an imaginary quadratic field $K = \mathbb{Q}(\sqrt{D})$
(of discriminant $D < 0$) that tends to $\infty$ as $|D| \to \infty$.

Dorian Goldfeld (1976, *Bull. Amer. Math. Soc.* 82; 1985, *Astérisque* 133–134)
proved that the existence of an elliptic curve over $\mathbb{Q}$ whose Hasse–Weil
$L$-function vanishes to analytic order at least $3$ at $s = 1$ yields an
effective lower bound $h(D) \gg_\varepsilon (\log |D|)^{1 - \varepsilon}$.
Benedict Gross and Don Zagier (1986, *Invent. Math.* 84, 225–320) supplied such
an elliptic curve (of conductor $5077$, $y^2 + y = x^3 - 7x + 6$), and Joseph
Oesterlé (1985, *Sém. Bourbaki* Exp. 631, *Astérisque* 121–122, 309–323,
Théorème 3) derived the completely explicit unconditional inequality
$$
  h(K) > \frac{1}{7000} (\log |D|)
    \prod_{\substack{p \mid D \\ p \ne |D|}}
      \left(1 - \frac{\lfloor 2\sqrt{p} \rfloor}{p + 1}\right)
$$
valid for every imaginary quadratic field $K$ of discriminant $D < 0$.
-/

/-- **Goldfeld–Gross–Zagier–Oesterlé effective imaginary quadratic class number
bound.** For every quadratic number field $K$ of negative discriminant
$D = \mathrm{discr}(K) < 0$, with $\Delta = |D|$, the class number $h(K)$
satisfies
$\frac{1}{7000} (\log \Delta) \prod_{p \mid \Delta,\, p \ne \Delta}
  (1 - \lfloor 2\sqrt{p}\rfloor / (p + 1)) < h(K)$. -/
@[eval_problem]
theorem goldfeld_gross_zagier_class_number
    (K : Type) [Field K] [NumberField K]
    (hdeg : Module.finrank ℚ K = 2) (hneg : NumberField.discr K < 0) :
    let Δ : ℕ := (NumberField.discr K).natAbs
    (1 / 7000 : ℝ) * Real.log (Δ : ℝ) *
      (∏ p ∈ Δ.primeFactors.erase Δ,
        (1 - (Nat.floor (2 * Real.sqrt (p : ℝ)) : ℝ) / ((p : ℝ) + 1))) <
      (NumberField.classNumber K : ℝ) := by
  sorry

end NumberTheory
end LeanEval
