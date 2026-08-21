import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.Calculus.IteratedDeriv.Defs
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Viscosity solutions and hyperbolic motions:
# a new PDE method for the N-body problem

We formalise the statement of the main result from E. Maderna and A. Venturelli,
`Viscosity solutions and hyperbolic motions: a new PDE method for the N-body problem`,
Annals of Math, 192 (2) 2020.
-/

set_option autoImplicit false

namespace ViscositySolutions

open Filter Gradient Real Set

/- Let `E` be a Euclidean Space. -/
variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [FiniteDimensional ℝ E]

variable {N : ℕ}

local notation "ℝᴺ" => Fin N → ℝ

local notation "Eᴺ" => EuclideanSpace E (Fin N)

section Definitions

/-- Given `x : Eᴺ` we define `rᵢⱼ = ‖xᵢ - xⱼ‖`. -/
def r (x : Eᴺ) (i j : Fin N) : ℝ := dist (x i) (x j)

/-- Given masses `m : ℝᴺ`, `x : Eᴺ` we define the norm of `x` with respect to the mass scalar
product by `‖x‖ₘ := √(∑ i, mᵢ * ‖xᵢ‖²)`. -/
noncomputable
def weightedNorm (m : ℝᴺ) (x : Eᴺ) : ℝ := sqrt (∑ i, m i * ‖x i‖ ^ 2)

/-- Given masses `m : ℝᴺ`, `f : Eᴺ → ℝ` we define the gradient of `f` with respect to the mass
scalar product by `(∇ₘ f x)ᵢ := mᵢ⁻¹ • (∇ f x)ᵢ` (so that `∇ₘ f x` is the unique vector such that
for any `v : Eᴺ`, `Df(x)(v) = ∑ i, ⟨∇f(x)ᵢ, vᵢ⟩ = ∑ i, mᵢ ⟨∇ₘf(x)ᵢ, vᵢ⟩ = ⟨∇ₘf(x),v⟩ₘ`). -/
noncomputable
def weightedGrad (m : ℝᴺ) (f : Eᴺ → ℝ) (x : Eᴺ) : Eᴺ where
  ofLp i := (m i)⁻¹ • (∇ f x) i

@[inherit_doc] notation "‖" x "‖_["m"]" => weightedNorm m x

@[inherit_doc] notation "∇_["m"]" => weightedGrad m

/-- We define the `Newtonian potential` by the formula:

`U(x) := ∑ i < j, mᵢ * mⱼ * rᵢⱼ⁻¹`. -/
noncomputable
def U (m : ℝᴺ) (x : Eᴺ) : ℝ := ∑ j, ∑ i < j, m i * m j * (r x i j)⁻¹

/-- We say that a configuration `x : Eᴺ` is without collisions if `rᵢⱼ ≠ 0` for each `i ≠ j`. -/
def WithoutCollisions (x : Eᴺ) : Prop := ∀ i j, i ≠ j → r x i j ≠ 0

/-- Given masses `m : ℝᴺ`, we say that `x : ℝ → Eᴺ` is a solution to the N-body problem if
`x ∈ C²((0,∞))`, `x` is continuous at `0`, and for all `t > 0`, `x'' = ∇ₘ U(x(t))`. -/
structure IsNBodySolution (m : ℝᴺ) (x : ℝ → Eᴺ) where
  contDiff : ContDiffOn ℝ 2 x (Ioi 0)
  continuousAt_zero : ContinuousAt x 0
  eq : ∀ t > 0, iteratedDeriv 2 x t = ∇_[m] (U m) (x t)

end Definitions



end ViscositySolutions
