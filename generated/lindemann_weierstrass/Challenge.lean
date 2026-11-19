import Mathlib

open Polynomial

theorem lindemann_weierstrass {n : ℕ} (x : Fin n → ℂ)
    (h_alg : ∀ i, IsAlgebraic ℚ (x i))
    (h_lin : LinearIndependent ℚ x) :
    AlgebraicIndependent ℚ (fun i => Complex.exp (x i)) := by
  sorry
