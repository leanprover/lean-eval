/-
Copyright (c) 2026 Justus Springer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Justus Springer, Mathias Stout
-/

import Mathlib.ModelTheory.Algebra.Ring.Basic
import Mathlib.ModelTheory.Definability
import Mathlib.NumberTheory.Height.NumberField
import EvalTools.Markers

/-!
# Main Statement from Wilkie's conjecture for Pfaffian structures

We formalise the statement of the main result from G. Binyamini, D. Novikov, and B. Zak,
`Wilkie's conjecture for Pfaffian structures`, Annals of Math, 199 (2) 2024.
-/

set_option autoImplicit false

noncomputable section

namespace WilkiesConjecture

open FirstOrder Language IntermediateField

/-- The type of function symbols for `Language.exp`. The only function symbol is a unary `exp`. -/
inductive expFunc : ℕ → Type
  | exp : expFunc 1

/-- The language consisting of a single symbol `exp`. -/
def Language.exp : Language where
  Functions := expFunc
  Relations _ := Empty
  deriving Language.IsAlgebraic

/-- We endow the real numbers with the structure of `Language.exp`.
The `exp` symbol is interpreted by `Real.exp`. -/
instance : Language.exp.Structure ℝ where
  funMap {n} f := match n, f with
    | 1, .exp => fun x ↦ Real.exp (x 0)

/-- Endow the real numbers with a `CompatibleRing` instance
(which extends `Language.ring.Structure`). -/
instance : Ring.CompatibleRing ℝ := Ring.compatibleRingOfRing ℝ

/-- The language of rings plus exponentials contains function symbols `(+,*,-,0,1,exp)`. -/
abbrev expRing := Language.ring.sum Language.exp

variable {n : ℕ}

local notation "ℝⁿ" => Fin n → ℝ

/-- A set `X ⊆ ℝⁿ` is called semialgebraic if it is definable in the language of rings over `ℝ`. -/
def IsSemialgebraic (X : Set ℝⁿ) : Prop :=
  Set.Definable Set.univ Language.ring X

/-- A set `X ⊆ ℝⁿ` is definable in `ℝₑₓₚ` if it is definable in the language of rings + `exp`. -/
def IsRExpDefinable (X : Set ℝⁿ) : Prop :=
  Set.Definable Set.univ expRing X

/-- If `X ⊆ ℝⁿ` then we denote by `Xᵃˡᵍ` the union of all connected,
positive-dimensional semialgebraic sets contained in X. Note that here, we say "infinite"
instead of positive-dimensional, which is equivalent in this setting. -/
def _root_.Set.alg (X : Set ℝⁿ) : Set ℝⁿ :=
  sSup { Y : Set ℝⁿ | Y ⊆ X ∧ IsSemialgebraic Y ∧ Y.Infinite ∧ IsConnected Y }

/-- If `X ⊆ ℝⁿ` then we denote `Xᵗʳᵃⁿˢ := X \ Xᵃˡᵍ`. -/
def _root_.Set.trans (X : Set ℝⁿ) : Set ℝⁿ := X \ X.alg

/-- We extend the multiplicative Weil height on `ℝ` to `ℝⁿ` by taking the maximum
of the heights of the coordinates. -/
def height (a : ℝⁿ) : ℝ := ⨆ i, NumberField.absMulHeight₁ (a i)

/-- For `g H : ℕ` we define `X(g,H) := {x ∈ X : [Q(x) : Q] ≤ g, H(x) ≤ H}`. -/
def degreeHeightLE (X : Set ℝⁿ) (g H : ℕ) : Set ℝⁿ :=
  { x ∈ X | (∀ i, IsIntegral ℚ (x i)) ∧
    Module.finrank ℚ (IntermediateField.adjoin ℚ (Set.range x)) ≤ g ∧ height x ≤ H }

/--
Statement of Corollary 1 (Wilkie's conjecture):

Let `X` be definable in `ℝₑₓₚ`. Then `#Xᵗʳᵃⁿˢ(g,H) ≤ poly_X (g,log H)`.
-/
@[eval_problem]
theorem corollary_1 (X : Set ℝⁿ) (h : IsRExpDefinable X) :
    ∃ f : MvPolynomial (Fin 2) ℝ, ∀ (g H : ℕ),
      Nat.card (degreeHeightLE X.trans g H) ≤ f.eval ![(g : ℝ), Real.log H] := by
  sorry

end WilkiesConjecture

end
