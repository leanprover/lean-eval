import ChallengeDeps
import Submission

open LeanEval.GroupTheory.BooneHigmanEmbedding

theorem boone_higman_embedding {G H K : Type*} [Group G] [Group H] [Group K]
    [IsSimpleGroup H] [Group.IsFinitelyPresented K]
    (f : G →* H) (hf : Function.Injective f)
    (g : H →* K) (hg : Function.Injective g)
    {n : ℕ} (φ : FreeGroup (Fin n) →* G)
    (hsurj : Function.Surjective φ)
    (hker : (MonoidHom.ker φ).IsNormalClosureFG) :
    WordProblemSolvable φ := by
  exact Submission.boone_higman_embedding f hf g hg φ hsurj hker
