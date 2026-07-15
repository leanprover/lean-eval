import ChallengeDeps

open LeanEval.Physics
open ComplexOrder

variable {A B C : Type*}
variable [Fintype A] [Fintype B] [Fintype C]
variable [DecidableEq A] [DecidableEq B] [DecidableEq C]
variable [Nonempty A] [Nonempty B] [Nonempty C]

theorem strong_subadditivity (M_ABC : Matrix (A × B × C) (A × B × C) ℂ) (h : M_ABC.PosSemidef) :
    let M_AB : Matrix (A × B) (A × B) ℂ :=
      .traceRight <| M_ABC.reindex (.symm <| .prodAssoc ..) (.symm <| .prodAssoc ..)
    let M_BC : Matrix (B × C) (B × C) ℂ := M_ABC.traceLeft
    let M_B : Matrix B B ℂ := M_BC.traceRight
    entropy M_ABC + entropy M_B ≤ entropy M_AB + entropy M_BC := by
  sorry
