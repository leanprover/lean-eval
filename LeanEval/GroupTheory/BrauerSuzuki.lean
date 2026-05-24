import Mathlib
import EvalTools.Markers
import LeanEval.GroupTheory.Defs.OddCore

namespace LeanEval
namespace GroupTheory

open LeanEval.GroupTheory.Defs

/-!
# Brauer–Suzuki theorem on generalized quaternion Sylow 2-subgroups

Let `G` be a finite group whose Sylow 2-subgroups are generalized
quaternion (i.e., isomorphic to `QuaternionGroup (2^(n-1))` for some
`n ≥ 2`). Let `t` be the unique involution of any (equivalently, every)
Sylow 2-subgroup. Then the image of `t` in `G / O(G)` is central, where
`O(G)` is the largest normal subgroup of `G` of odd order.

R. Brauer and M. Suzuki, "On finite groups of even order whose 2-Sylow
group is a quaternion group", Proc. Nat. Acad. Sci. U.S.A. 45 (1959).
This was the precursor of Glauberman's Z*-theorem (1966) and the
historical seed of the local-analysis programme in CFSG.

The conclusion is phrased entirely in the quotient `G / O(G)`,
applied to the image of `t` under `QuotientGroup.mk`; the value of
`t : G` only enters via that map.

Introduces `Defs/OddCore.lean` since Mathlib has no `oddCore`/`O(G)`
operation.
-/

/-- **Brauer–Suzuki theorem (quaternion case).** -/
@[eval_problem]
theorem brauer_suzuki {G : Type*} [Group G] [Finite G]
    (n : ℕ) (hn : 2 ≤ n)
    (P : Sylow 2 G)
    (hquat : Nonempty ((P : Subgroup G) ≃* QuaternionGroup (2 ^ (n - 1))))
    (t : G) (ht_mem : t ∈ (P : Subgroup G)) (ht_ord : orderOf t = 2) :
    (QuotientGroup.mk t : G ⧸ oddCore G) ∈
      Subgroup.center (G ⧸ oddCore G) := by
  sorry

end GroupTheory
end LeanEval
