import ChallengeDeps
import Submission

open LeanEval.Topology
open Geometry

theorem manolescu_triangulation_disproof :
    ∀ n : ℕ, 5 ≤ n → ∃ M : ClosedTopManifold n, ¬ Triangulable M := by
  exact Submission.manolescu_triangulation_disproof
