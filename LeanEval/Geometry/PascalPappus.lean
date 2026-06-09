import Mathlib
import EvalTools.Markers

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

/-- **Pascal's theorem.** Six distinct points on a non-singular conic determine
three collinear intersection points `Aᵢ Bⱼ ∩ Aⱼ Bᵢ`. -/
@[eval_problem]
theorem pascal
    (M : Matrix (Fin 3) (Fin 3) ℝ) (hMsymm : M.IsSymm) (hMdet : M.det ≠ 0)
    (a₁ a₂ a₃ b₁ b₂ b₃ : Fin 3 → ℝ)
    (ha₁ : a₁ ≠ 0) (ha₂ : a₂ ≠ 0) (ha₃ : a₃ ≠ 0)
    (hb₁ : b₁ ≠ 0) (hb₂ : b₂ ≠ 0) (hb₃ : b₃ ≠ 0)
    (hdist : [a₁, a₂, a₃, b₁, b₂, b₃].Pairwise (fun v w => ¬ SamePoint v w))
    (hA₁ : OnConic M a₁) (hA₂ : OnConic M a₂) (hA₃ : OnConic M a₃)
    (hB₁ : OnConic M b₁) (hB₂ : OnConic M b₂) (hB₃ : OnConic M b₃) :
    Collinear3 (meet a₁ b₂ a₂ b₁) (meet a₁ b₃ a₃ b₁) (meet a₂ b₃ a₃ b₂) := by
  sorry

/-- **Pappus's hexagon theorem.** With `A₁,A₂,A₃` collinear and `B₁,B₂,B₃`
collinear, the three intersection points `Aᵢ Bⱼ ∩ Aⱼ Bᵢ` are collinear. -/
@[eval_problem]
theorem pappus
    (a₁ a₂ a₃ b₁ b₂ b₃ : Fin 3 → ℝ)
    (ha₁ : a₁ ≠ 0) (ha₂ : a₂ ≠ 0) (ha₃ : a₃ ≠ 0)
    (hb₁ : b₁ ≠ 0) (hb₂ : b₂ ≠ 0) (hb₃ : b₃ ≠ 0)
    (hdist : [a₁, a₂, a₃, b₁, b₂, b₃].Pairwise (fun v w => ¬ SamePoint v w))
    (hA : Collinear3 a₁ a₂ a₃) (hB : Collinear3 b₁ b₂ b₃) :
    Collinear3 (meet a₁ b₂ a₂ b₁) (meet a₁ b₃ a₃ b₁) (meet a₂ b₃ a₃ b₂) := by
  sorry

end LeanEval.Geometry.PascalPappus
