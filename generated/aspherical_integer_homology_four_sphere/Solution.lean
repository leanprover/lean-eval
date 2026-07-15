import ChallengeDeps
import Submission

open LeanEval.Topology
open CategoryTheory AlgebraicTopology
open Metric (sphere)

theorem aspherical_integer_homology_four_sphere :
    ∃ M : Closed4Manifold, M.IsAspherical ∧ M.IsIntegerHomologySphere := by
  exact Submission.aspherical_integer_homology_four_sphere
