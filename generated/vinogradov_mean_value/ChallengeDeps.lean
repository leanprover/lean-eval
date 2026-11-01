import Mathlib

/-!
# Vinogradov mean value theorem

https://en.wikipedia.org/wiki/Vinogradov%27s_mean-value_theorem

Given integers `s, k ≥ 1`, let J_{s,k}(X) denote the number of integral solutions to the system of
`k` equations `x₁ʲ + … + xₛʲ = y₁ʲ + … + yₛʲ` with `1 ≤ xᵢ, yᵢ ≤ X` for `i = 1, …, s`.
Then J_{s,k}(X) ≪ X^ε(X^s + X^{2s-k(k+1)/2}) for every ε > 0.

This was proved by Jean Bourgain, Ciprian Demeter, and Larry Guth and by a different method
by Trevor Wooley.

## References

Lillian B. Pierce. The Vinogradov Mean Value Theorem [after Wooley, and Bourgain, Demeter and Guth].
https://arxiv.org/abs/1707.00119

Bourgain, Jean; Demeter, Ciprian; Guth, Larry (2016).
"Proof of the main conjecture in Vinogradov's Mean Value Theorem for degrees higher than three".
Ann. of Math. 184 (2): 633–682. arXiv:1512.01565. doi:10.4007/annals.2016.184.2.7.

Wooley, Trevor D. (2019). "Nested efficient congruencing and relatives of Vinogradov's mean value theorem".
Proceedings of the London Mathematical Society. 118 (4): 942–1016. arXiv:1708.01220. doi:10.1112/plms.12204.
-/

namespace LeanEval.NumberTheory.VinogradovMeanValue

/-- The quantity J_{s,k}(X) that counts solutions of a certain system of
Diophantine equations in a cube. -/
def J (s k X : ℕ) : ℝ :=
  Finset.card {(x, y) : (Fin s → Finset.Icc 1 X) × (Fin s → Finset.Icc 1 X) |
    ∀ j ≤ k, ∑ i, (x i).1 ^ j = ∑ i, (y i).1 ^ j}



end LeanEval.NumberTheory.VinogradovMeanValue
