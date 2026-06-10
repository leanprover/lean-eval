import Mathlib

namespace LeanEval.Geometry.PascalPappus

/-!
# Pascal's theorem and Pappus's hexagon theorem

`pascal` (Pascal 1639): six points on a non-singular conic give three collinear
intersection points. `pappus` (Pappus, c. 320 AD): the degenerate-conic case
with the six points on two lines. Trusted helpers (`SamePoint`, `OnConic`,
`meet`, `Collinear3`) are non-holes. Mathlib has the cross product `⨯₃` and
projective vocabulary but neither theorem.
Category-(b) candidates from §146 of the Knill survey.
-/

open Matrix

/-- Two homogeneous coordinate vectors represent the same projective point. -/
def SamePoint (v w : Fin 3 → ℝ) : Prop := ∃ c : ℝ, c ≠ 0 ∧ w = c • v

/-- `[v]` lies on the conic `xᵀ M x = 0`. -/
def OnConic (M : Matrix (Fin 3) (Fin 3) ℝ) (v : Fin 3 → ℝ) : Prop :=
  v ⬝ᵥ (M *ᵥ v) = 0

/-- Intersection (meet) of line `[a][b]` and line `[c][d]`. -/
def meet (a b c d : Fin 3 → ℝ) : Fin 3 → ℝ := (a ⨯₃ b) ⨯₃ (c ⨯₃ d)

/-- Three projective points are collinear (vanishing triple product). -/
def Collinear3 (p q r : Fin 3 → ℝ) : Prop := p ⬝ᵥ (q ⨯₃ r) = 0



end LeanEval.Geometry.PascalPappus
