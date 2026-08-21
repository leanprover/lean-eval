import Mathlib.Analysis.VonNeumannAlgebra.Basic
import Mathlib.Analysis.InnerProductSpace.WeakOperatorTopology
import Mathlib.Topology.Algebra.Module.Spaces.PointwiseConvergenceCLM
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers

namespace Submission

theorem vonNeumann_doubleCommutant_tfae {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (S : StarSubalgebra ℂ (H →L[ℂ] H)) :
    List.TFAE
      [ Set.centralizer (Set.centralizer (S : Set (H →L[ℂ] H))) = S
      , IsClosed
          (ContinuousLinearMapWOT.ofCLM '' (S : Set (H →L[ℂ] H)))
      , IsClosed
          (ContinuousLinearMap.toPointwiseConvergenceCLM ℂ (RingHom.id ℂ) H H ''
            (S : Set (H →L[ℂ] H))) ] := by
  sorry

end Submission
