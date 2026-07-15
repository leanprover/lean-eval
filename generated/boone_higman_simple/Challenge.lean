import ChallengeDeps

open LeanEval.GroupTheory.BooneHigmanSimpleProblem

theorem boone_higman_simple {G : Type*} [Group G] [IsSimpleGroup G]
    {n : ℕ} (φ : FreeGroup (Fin n) →* G)
    (_hsurj : Function.Surjective φ)
    (_hker : (MonoidHom.ker φ).IsNormalClosureFG) :
    WordProblemSolvable φ := by
  sorry
