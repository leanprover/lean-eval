import ChallengeDeps
import Submission.Helpers

open HassePrincipleRandomFano
open MvPolynomial Filter NumberField Real
open scoped LinearAlgebra.Projectivization

variable (d n : ℕ)

namespace Submission

theorem theorem_1_1 (hd : 2 ≤ d) (h₁ : d ≤ n) (h₂ : (d, n) ≠ (3, 3)) :
    Tendsto (ρ d n) atTop (nhds (ρLoc d n)) := by
  sorry

end Submission
