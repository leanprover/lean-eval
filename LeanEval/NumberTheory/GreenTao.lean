import EvalTools.Markers
import Mathlib.Data.Nat.Prime.Defs

/-! # Green-Tao theorem on primes in arithmetic progressions

There exist arbitrarily-long arithmetic progression of primes.

Ben Green and Terence Tao. *The primes contain arbitrarily long arithmetic progressions* (2004).
-/

/-- (Possibly trivial) arithmetic progression in any type equipped with addition. -/
def List.IsArithProg {α : Type*} [Add α] (l : List α) : Prop :=
  ∀ {x y z : α}, [x, y, z] <:+: l → x + y = z + z

/-- The *Green-Tao Theorem*: there are arbitrarily long arithmetic progressions of primes. -/
@[eval_problem]
theorem green_tao (k : ℕ) :
  ∃ ps : List ℕ, (∀ p ∈ ps, p.Prime) ∧ ps.IsArithProg ∧ k ≤ ps.length ∧ ps.Nodup := sorry
