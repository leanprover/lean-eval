import Mathlib
import EvalTools.Markers

namespace LeanEval
namespace GroupTheory

/-!
# Burnside's normal `p`-complement theorem

Let `G` be a finite group, `p` a prime, and `P` a Sylow `p`-subgroup of `G`.
If `P` is central in its normalizer (equivalently, `N_G(P) ≤ C_G(P)`), then
`G` has a *normal `p`-complement*: a normal subgroup `N ⊴ G` with `N ⊓ P = 1`,
`N ⊔ P = ⊤`, and `(|N|, p) = 1`.

Proved by William Burnside (1900) using his transfer homomorphism. The
result is the foundational example of *transfer*-based local-to-global
arguments in finite group theory and was the original prototype for the
modern theory of fusion (Alperin, Stallings, Mislin). Together with the
focal subgroup theorem and Grün's theorems, it sits at the entry point of
the CFSG local analysis programme.

Note: Mathlib has the underlying construction — the *kernel of the
transfer to `P`* is a normal `p`-complement, see
`MonoidHom.ker_transferSylow_isComplement'`. The eval problem here is to
recover the named theorem statement (existence of *some* normal subgroup
witnessing the four conditions) from that machinery.

We add the coprimality condition `(|N|, p) = 1` explicitly, since the
combination `N.Normal ∧ N ⊓ P = 1 ∧ N ⊔ P = ⊤` alone does not force `N` to
be the Hall `p'`-complement.
-/

/-- **Burnside's normal `p`-complement theorem.** -/
@[eval_problem]
theorem burnside_normal_p_complement
    {G : Type*} [Group G] [Finite G]
    {p : ℕ} [Fact p.Prime] (P : Sylow p G)
    (h : Subgroup.normalizer (P : Subgroup G) ≤ Subgroup.centralizer (P : Set G)) :
    ∃ N : Subgroup G, N.Normal ∧ N ⊓ (P : Subgroup G) = ⊥ ∧
      N ⊔ (P : Subgroup G) = ⊤ ∧ (Nat.card N).Coprime p := by
  sorry

end GroupTheory
end LeanEval
