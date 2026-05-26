import Mathlib

namespace LeanEval
namespace GroupTheory
namespace Defs

/-- `oddCore G` is the largest normal subgroup of `G` of odd order — the
supremum of all normal subgroups whose cardinality is odd. Classically
denoted `O(G)` (in older notation `O_{2'}(G)`).

For a finite group, the join of two normal odd-order subgroups is again
a normal odd-order subgroup, and finiteness bounds the chain — so the
supremum is itself a normal subgroup of odd order, agreeing with the
textbook definition. For an infinite group the definition still makes
sense as a subgroup, though it need not be of odd order.
-/
def oddCore (G : Type*) [Group G] : Subgroup G :=
  sSup {N : Subgroup G | N.Normal ∧ Odd (Nat.card N)}

/-- The odd core is normal: conjugation by any `g : G` fixes every normal
subgroup in the family pointwise, hence fixes their supremum setwise. -/
instance oddCore_normal (G : Type*) [Group G] : (oddCore G).Normal where
  conj_mem n hn g := by
    have hn' : n ∈ ⨆ N : {N : Subgroup G // N.Normal ∧ Odd (Nat.card N)},
        (N : Subgroup G) := by
      rwa [oddCore, sSup_eq_iSup'] at hn
    refine Subgroup.iSup_induction (C := fun y => g * y * g⁻¹ ∈ oddCore G)
      _ hn' (fun N x hxN => ?_) ?_ (fun x y hx hy => ?_)
    · -- `N.val` is a normal subgroup, so `g * x * g⁻¹ ∈ N.val ≤ oddCore G`
      have hN_norm : (N : Subgroup G).Normal := N.prop.1
      exact (le_sSup N.prop : (N : Subgroup G) ≤ oddCore G)
        (hN_norm.conj_mem x hxN g)
    · -- `g * 1 * g⁻¹ = 1 ∈ oddCore G`
      show g * 1 * g⁻¹ ∈ oddCore G
      simp
    · -- `g * (x * y) * g⁻¹ = (g * x * g⁻¹) * (g * y * g⁻¹)`
      show g * (x * y) * g⁻¹ ∈ oddCore G
      have h_distr : g * (x * y) * g⁻¹ = (g * x * g⁻¹) * (g * y * g⁻¹) := by
        group
      rw [h_distr]
      exact mul_mem hx hy

end Defs
end GroupTheory
end LeanEval
