import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission

open scoped Manifold ContDiff

local notation "𝔼" => EuclideanSpace ℝ (Fin 4)

theorem four_manifold_not_smooth :
    ∃ (M : Type*) (_ : TopologicalSpace M) (_ : T2Space M) (_: CompactSpace M)
      (_ : SimplyConnectedSpace M) (_ : Nonempty (ChartedSpace 𝔼 M)),
      ∀ (_ : ChartedSpace 𝔼 M), ¬ IsManifold (𝓡 4) ∞ M := by
  exact Submission.four_manifold_not_smooth
