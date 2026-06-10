import ChallengeDeps

open LeanEval.Geometry.PascalPappus
open Matrix

theorem pascal (M : Matrix (Fin 3) (Fin 3) ℝ) (hMsymm : M.IsSymm) (hMdet : M.det ≠ 0)
    (a₁ a₂ a₃ b₁ b₂ b₃ : Fin 3 → ℝ)
    (ha₁ : a₁ ≠ 0) (ha₂ : a₂ ≠ 0) (ha₃ : a₃ ≠ 0)
    (hb₁ : b₁ ≠ 0) (hb₂ : b₂ ≠ 0) (hb₃ : b₃ ≠ 0)
    (hdist : [a₁, a₂, a₃, b₁, b₂, b₃].Pairwise (fun v w => ¬ SamePoint v w))
    (hA₁ : OnConic M a₁) (hA₂ : OnConic M a₂) (hA₃ : OnConic M a₃)
    (hB₁ : OnConic M b₁) (hB₂ : OnConic M b₂) (hB₃ : OnConic M b₃) :
    Collinear3 (meet a₁ b₂ a₂ b₁) (meet a₁ b₃ a₃ b₁) (meet a₂ b₃ a₃ b₂) := by
  sorry
