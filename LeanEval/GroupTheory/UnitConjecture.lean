/-
Copyright (c) 2026 Thomas Browning. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Thomas Browning
-/

import Mathlib.Algebra.Field.ZMod
import Mathlib.Algebra.MonoidAlgebra.Defs
import Mathlib.GroupTheory.PresentedGroup
import EvalTools.Markers

/-!
# Main Statement from A counterexample to the unit conjecture for group rings

We formalise the statement of the main result from G. Gardam,
`A counterexample to the unit conjecture for group rings`, Annals of Math, 194 (3) 2021.
-/

set_option autoImplicit false

noncomputable section

namespace UnitConjecture

/-- The two generators of the group `P` defined in Theorem A of the paper. -/
inductive generators where
  | a
  | b

/-- The first generator of the group `P` defined in Theorem A of the paper. -/
def a : FreeGroup generators := .of generators.a

/-- The second generator of the group `P` defined in Theorem A of the paper. -/
def b : FreeGroup generators := .of generators.b

/-- The relations defining the group `P` defined in Theorem A of the paper. -/
def relations : Set (FreeGroup generators) :=
  {b⁻¹ * a ^ 2 * b * a ^ 2, a⁻¹ * b ^ 2 * a * b ^ 2}

/-- The group `P` defined in Theorem A of the paper. -/
def P := PresentedGroup relations
deriving Coe (FreeGroup generators), Group

/-- The element `x` defined in Theorem A of the paper. -/
def x : P := a ^ 2

/-- The element `y` defined in Theorem A of the paper. -/
def y : P := b ^ 2

/-- The element `z` defined in Theorem A of the paper. -/
def z : P := (a * b) ^ 2

/-- The group ring `𝔽₂[P]` defined in Theorem A of the paper. -/
abbrev R := MonoidAlgebra (ZMod 2) P

instance : Coe P R where
  coe := MonoidAlgebra.of (ZMod 2) P

/-- The element `p` defined in Theorem A of the paper. -/
def p : R := (1 + x) * (1 + y) * (1 + z⁻¹)

/-- The element `q` defined in Theorem A of the paper. -/
def q : R := x⁻¹ * y⁻¹ + x + y⁻¹ * z + z

/-- The element `r` defined in Theorem A of the paper. -/
def r : R := 1 + x + y⁻¹ * z + x * y * z

/-- The element `s` defined in Theorem A of the paper. -/
def s : R := 1 + (x + x⁻¹ + y + y⁻¹) * z⁻¹

/-- The nontrivial unit defined in Theorem A of the paper. -/
def u : R := p + q * a + r * b + s * (a * b)

/--
Statement of Theorem A:

Let P be the torsion-free group defined by the presentation
`⟨a,b | b⁻¹a²b = a⁻², a⁻¹b²a = b⁻²⟩`, and set `x = a²`, `y = b²`, `z = (ab)²`. Set
`p = (1 + x)(1 + y)(1 + z⁻¹)`, `q = x⁻¹y⁻¹ + x + y⁻¹z + z`,
`r = 1 + x + y⁻¹z + xyz`, `s = 1 + (x + x⁻¹ + y + y⁻¹)z⁻¹`.
Then `p + qa + rb + sab` is a non-trivial unit in the group ring `𝔽₂[P]`.
-/
@[eval_problem]
theorem theorem_A : (∀ g : P, ∀ n ≠ 0, g ^ n = 1 → g = 1) ∧ IsUnit u ∧ ¬ ∃ g : P, u = g := by
  sorry

end UnitConjecture

end
