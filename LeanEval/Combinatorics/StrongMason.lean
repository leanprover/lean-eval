import Mathlib
import EvalTools.Markers

namespace LeanEval.Combinatorics.StrongMason

/-!
# The strong Mason conjecture

For a finite matroid, let `I k` be the number of independent sets of
cardinality `k`. Mason's strongest conjecture says that the normalized
sequence `I k / (n.choose k)` is log-concave, where `n` is the cardinality
of the ground set. Branden and Huh proved this using Lorentzian polynomials;
Anari, Liu, Oveis Gharan, and Vinzant obtained the result independently.

Mathlib supplies the matroid axioms and their independent-set API. The
inequality below clears the binomial denominators, so it can be stated
entirely in `Nat`.
-/

/-- The number of independent `k`-element subsets of a finite matroid's
ground set. -/
noncomputable def independentSetCount {α : Type*} (M : Matroid α) [M.Finite]
    (k : ℕ) : ℕ :=
  letI := Classical.decEq α
  letI : DecidablePred (fun I : Finset α => M.Indep (I : Set α)) :=
    Classical.decPred _
  ((M.ground_finite.toFinset.powersetCard k).filter
    fun I : Finset α => M.Indep (I : Set α)).card

/-- A finite sanity check for the trusted counting definition: the free
matroid on four elements has six independent two-element sets. -/
theorem independentSetCount_freeOn_fin_four_two :
    independentSetCount (Matroid.freeOn (Set.univ : Set (Fin 4))) 2 = 6 := by
  simp [independentSetCount]
  norm_num [Nat.choose]

/-- A second sanity check which exercises the independence filter: a
three-element loopy matroid has no independent singleton. -/
theorem independentSetCount_loopyOn_fin_three_one :
    independentSetCount (Matroid.loopyOn (Set.univ : Set (Fin 3))) 1 = 0 := by
  simp [independentSetCount, Matroid.loopyOn_indep_iff]
  intro I hI rfl
  simp at hI

/-- **The strong Mason conjecture** (Branden-Huh; independently
Anari-Liu-Oveis Gharan-Vinzant). If `I k` counts the independent sets of
size `k` in a finite matroid on `n` elements, then

`I k ^ 2 * k * (n - k) >= I (k - 1) * I (k + 1) * (k + 1) * (n - k + 1)`.

Equivalently, `I k / n.choose k` is a log-concave sequence. -/
@[eval_problem]
theorem strong_mason_conjecture {α : Type*} (M : Matroid α) [M.Finite]
    (k : ℕ) (hk : 0 < k) (hkn : k < M.E.ncard) :
    independentSetCount M (k - 1) * independentSetCount M (k + 1) *
          (k + 1) * (M.E.ncard - k + 1) ≤
      independentSetCount M k ^ 2 * k * (M.E.ncard - k) := by
  sorry

end LeanEval.Combinatorics.StrongMason
