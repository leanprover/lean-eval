/-
Copyright (c) 2025 Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Katerina Hristova
-/

import Mathlib.Analysis.SpecialFunctions.Complex.Circle
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Geometry.Manifold.SmoothEmbedding
import Mathlib.Topology.MetricSpace.Similarity
import EvalTools.Markers

/-!
# Main Statement from The rectangular peg problem

We formalise the statement of the main result from J. E. Greene and A. Lobb,
`The rectangular peg problem`, Annals of Math, 194 (2) 2021.
-/

set_option autoImplicit false

namespace RectangularPegProblem

open Manifold Complex Real

open scoped ContDiff

/-- A rectangle `R` in the complex plane with opposite corners `z` and `w` and rotated by an angle
`θ`. -/
noncomputable def R (z w : ℂ) (θ : Angle) : Fin 4 → ℂ :=
  ![z * θ.toCircle, (w.re + z.im * I) * θ.toCircle, w * θ.toCircle, (z.re + w.im * I) * θ.toCircle]

/--
Statement of Theorem:

For every smooth Jordan curve `γ` and rectangle `R` in the Euclidean plane,
there exists a rectangle similar to `R` whose vertices lie on `γ`.
Note: The paper models the Euclidean plane as the complex plane.
-/
@[eval_problem]
theorem theorem_1 (γ : Circle → ℂ) (z w : ℂ) (θ : Real.Angle)
    (hγ : IsSmoothEmbedding (𝓡 1) 𝓘(ℝ, ℂ) ∞ γ) :
    ∃ (θ' : Real.Angle), ∃ (z' w' : ℂ), Similar (R z w θ) (R z' w' θ') ∧
    ∀ i : Fin 4, R z' w' θ' i ∈ Set.range γ := by
  sorry

end RectangularPegProblem
