import Mathlib.Probability.HasLaw
import Mathlib.Probability.Distributions.Bernoulli
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statements from Singularity of random Bernoulli matrices

We formalise the statements of the main results from K. Tikhomirov,
`Singularity of random Bernoulli matrices`, Annals of Math, 191 (2) 2020.
-/

set_option autoImplicit false

namespace RandomBernoulliMatrices

open Matrix MeasureTheory ProbabilityTheory Measure Filter unitInterval

open scoped ENNReal

/-- We define the smallest singular value `σ_min` of a `n × m` matrix `M` by the formula

`σ_min(M) := inf_{‖x‖₂ = 1} ‖M x‖₂`. -/
noncomputable def σ_min {𝕜 n m : Type*} [Fintype n] [Fintype m] [DecidableEq m]
    [RCLike 𝕜] (M : Matrix n m 𝕜) :=
  ⨅ x : {x : EuclideanSpace 𝕜 m // ‖x‖ = 1}, ‖M.toEuclideanLin x‖

/-- We define the Rademacher measure as the probability measure on `ℝ`, which assigns
`1/2` mass to `1` and `1/2` mass to `-1`. -/
noncomputable def rademacherMeasure : Measure ℝ :=
  bernoulliMeasure 1 (-1) ⟨1 / 2, by norm_num⟩







end RandomBernoulliMatrices
