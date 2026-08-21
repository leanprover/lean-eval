import ChallengeDeps
import Submission

open HassePrincipleRandomFano
open MvPolynomial Filter NumberField Real
open scoped LinearAlgebra.Projectivization

variable (d n : ℕ)

theorem theorem_1_1 (hd : 2 ≤ d) (h₁ : d ≤ n) (h₂ : (d, n) ≠ (3, 3)) :
    Tendsto (ρ d n) atTop (nhds (ρLoc d n)) := by
  exact Submission.theorem_1_1 d n hd h₁ h₂
