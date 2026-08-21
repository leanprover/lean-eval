/-
Copyright (c) 2026 Thomas Browning, Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning, Katerina Hristova
-/

import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.InnerProductSpace.PiL2
import EvalTools.Markers

/-!
# Main Statement from The optimal paper Moebius band

We formalise the statement of the main result from R. E. Schwartz, `The optimal paper Moebius band`,
Annals of Math, 201 (1) 2025.
-/

set_option autoImplicit false

namespace OptimalMoebius

open Topology ContDiff

local notation "ℝ²" => EuclideanSpace ℝ (Fin 2)
local notation "ℝ³" => EuclideanSpace ℝ (Fin 3)

/-- The set of points `(x, y) ∈ ℝ²` with `0 ≤ x ≤ 1`. -/
abbrev unitStrip : Set ℝ² :=
  {x | x 0 ∈ Set.Icc 0 1}

/-- The map `(x, y) ↦ (1 - x, y + a)`. -/
def period (a : ℝ) : ℝ² → ℝ² :=
  fun x ↦ !₂[1 - x 0, x 1 + a]

/-- The set of points `(x, y) ∈ ℝ²` with `0 ≤ x ≤ 1` and `0 ≤ y < a`. -/
def fundamentalDomain (a : ℝ) : Set ℝ² :=
  {x | x 0 ∈ Set.Icc 0 1 ∧ x 1 ∈ Set.Ico 0 a}

/-- A Moebius embedding is defined in the paper to be a smooth isometric embedding.

We use a function `f` defined on all of `ℝ²`, but only impose conditions on `f` on the unit strip
`[0, 1] × ℝ`. We glue the strip into a Moebius band by imposing `f(1 - x, y + a) = f(x, y)`.

We require the map to be an embedding by requiring injectivity of `f` on a fundamental domain.
We require the embedding to be isometric by requiring the derivative of `f` to be an isometry.
-/
structure IsMoebiusEmbedding (a : ℝ) (f : ℝ² → ℝ³) : Prop where
  periodic : ∀ x ∈ unitStrip, f (period a x) = f x
  smooth : ContDiffOn ℝ ∞ f unitStrip
  isometry : ∀ x ∈ unitStrip, Isometry (fderivWithin ℝ f unitStrip x)
  embedding : Set.InjOn f (fundamentalDomain a)

/--
Statement of Theorem 1.1 (Main):

A smooth embedded paper Moebius band has aspect ratio greater than `√3`.
-/
@[eval_problem]
theorem theorem_1_1 (a : ℝ) (ha : a > 0) (f : ℝ² → ℝ³) (hf : IsMoebiusEmbedding a f) :
    a > √3 := by
  sorry

end OptimalMoebius
