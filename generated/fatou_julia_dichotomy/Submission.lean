import ChallengeDeps
import Submission.Helpers

open LeanEval.ComplexAnalysis.FatouJuliaProblem
open Function

namespace Submission

theorem julia_cantor_dichotomy (c : ℂ) :
    (c ∈ Mandelbrot → IsConnected (FilledJulia c)) ∧
    (c ∉ Mandelbrot → Nonempty ((FilledJulia c) ≃ₜ (ℕ → Bool))) := by
  sorry

end Submission
