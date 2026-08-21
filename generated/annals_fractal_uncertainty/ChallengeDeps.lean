import Mathlib.Analysis.Fourier.LpSpace
import Lake.Toml
import Lake.Util.Message
import Lean

/-!
# Main Statement from Fractal uncertainty in higher dimensions

We formalise the statement of the main result from A. Cohen,
`Fractal uncertainty in higher dimensions`, Annals of Math, 202 (1) 2025.
-/

set_option autoImplicit false

namespace FractalUncertainty

open MeasureTheory FourierTransform Metric

open scoped ENNReal

variable {d : ℕ}

local notation "ℝᵈ" => EuclideanSpace ℝ (Fin d)

/-- We say a set `X ⊂ ℝᵈ` is `ν`-porous on balls from scales `α₀` to `α₁` if, for every ball `B` of
diameter `α₀ < R < α₁`, there is some `x ∈ B` such that `closedBall x (ν * R) ∩ X = ∅`. -/
def PorousOnBalls (ν α₀ α₁ : ℝ) (X : Set ℝᵈ) : Prop :=
  ∀ y, ∀ R ∈ Set.Ioo α₀ α₁, ∃ x ∈ closedBall y (R / 2), closedBall x (ν * R) ∩ X = ∅

/-- We say a set `X` is `ν`-porous on lines from scales `α₀` to `α₁` if for all line segments `τ`
with length `α₀ < R < α₁`, there is some `x ∈ τ` such that `closedBall x (ν * R) ∩ X = ∅`. -/
def PorousOnLines (ν α₀ α₁ : ℝ) (X : Set ℝᵈ) : Prop :=
  ∀ (R : ℝ), R ∈ Set.Ioo α₀ α₁ → ∀ (y₁ y₂ : ℝᵈ), dist y₁ y₂ = R →
    ∃ x ∈ segment ℝ y₁ y₂, closedBall x (ν * R) ∩ X = ∅

/-- Given `a b : ℝ`, the cube `[a,b]ᵈ` in `ℝᵈ`. -/
abbrev cube (a b : ℝ) : Set ℝᵈ := EuclideanSpace.equiv (Fin d) ℝ ⁻¹' Set.univ.pi fun _ ↦ Set.Icc a b



end FractalUncertainty
