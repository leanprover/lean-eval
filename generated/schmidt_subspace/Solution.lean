import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

theorem schmidt_subspace (σ : Type*) [Fintype σ] (hσ : 2 ≤ Fintype.card σ)
    (L : σ → σ → ℂ)
    (alg : ∀ i j, IsAlgebraic ℚ (L i j)) (ind : LinearIndependent ℂ L)
    (ε : ℝ) (pos : 0 < ε) :
    ∃ s : Finset (σ → ℤ), 0 ∉ s ∧ ∀ x : σ → ℤ,
      ‖∏ i, ∑ j, L i j * x j‖ < ‖x‖ ^ (-ε) → ∃ c ∈ s, ∑ i, c i * x i = 0 := by
  exact Submission.schmidt_subspace σ hσ L alg ind ε pos
