import LeanEval.Combinatorics.UnitDistance
import EvalTools.Markers

namespace LeanEval
namespace Combinatorics

/-!
# Erdős's unit-distance conjecture is false

OpenAI, *Planar Point Sets with Many Unit Distances* (2026),
<https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-proof.pdf>.

In 1946 Erdős conjectured that
`ν(n) ≤ n^{1 + C / log log n}` for some absolute constant `C` and all
sufficiently large `n`. OpenAI's construction refutes this: there is an
absolute `δ > 0` and infinitely many `n` with `ν(n) ≥ n^{1+δ}`. In
particular no pair `(C, N)` of constants can make Erdős's inequality
hold for every `n ≥ N`.

## Construction sketch

The argument is a high-dimensional analogue of Erdős's classical
square-grid lower bound (which used Gaussian integers `ℤ[i]`). Replace
`ℚ(i)` by `K = L(i)` for `L` a totally real number field of growing
degree, in an infinite unramified pro-`3` tower in which a fixed set of
rational primes `q₁, …, q_t` (each `≡ 1 mod 4`) splits completely.

* **Arithmetic part.** Many split prime ideals give many norm-one
  elements `u ∈ K^×` via a class-group pigeonhole. Under every complex
  embedding `σ : K ↪ ℂ`, `σ(u)` has absolute value `1`, so `u` acts as
  a candidate unit translation in the Minkowski lattice.

* **Tower.** The Hajir–Maire class-field-theoretic construction
  (specialised to the unramified, `T`-split case) produces the
  required pro-`3` tower over a cyclic cubic base field, with Chebotarev
  choosing the split primes so that their Frobenius elements lie in the
  Frattini subgroup; Golod–Shafarevich keeps the tower infinite.

* **Geometric part.** Embedding `K` via its Minkowski map produces a
  high-dimensional lattice; cutting by a product of complex discs and
  projecting to the first complex coordinate yields a planar point set
  in which every translation by `Q^{-2} u` (with `u ∈ U`) contributes a
  unit-distance pair. A packing estimate bounds the cardinality
  uniformly in the field degree, giving `ν(P_j) ≥ |P_j|^{1+δ}` along an
  infinite subsequence.

The crucial quantitative input is that bounded root discriminants give
class numbers at most exponential in the field degree.
-/

/-- **OpenAI (2026), Theorem 1.1: Erdős's unit-distance conjecture is
false.**

There is an absolute `δ > 0` and infinitely many positive integers `n`
for which some `n`-point set `P ⊆ ℝ²` has at least `n^{1+δ}`
unit-distance pairs. Concretely: for every threshold `N` there exist
`n ≥ N` and a finite `P ⊆ ℝ²` with `|P| = n` and
`n^{1+δ} ≤ unitDist P`. -/
@[eval_problem]
theorem erdos_unit_distance_conjecture_false :
    ∃ δ : ℝ, 0 < δ ∧
      ∀ N : ℕ, ∃ (n : ℕ) (P : Finset E2),
        N ≤ n ∧ P.card = n ∧ (n : ℝ) ^ (1 + δ) ≤ (unitDist P : ℝ) := by
  sorry

end Combinatorics
end LeanEval
