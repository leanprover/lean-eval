import ChallengeDeps
import Submission

open LeanEval.ComplexAnalysis.FatouJuliaProblem
open Function

theorem julia_cantor_dichotomy (c : ℂ) :
    (c ∈ Mandelbrot → IsConnected (FilledJulia c)) ∧
    (c ∉ Mandelbrot → Nonempty ((FilledJulia c) ≃ₜ (ℕ → Bool))) := by
  exact Submission.julia_cantor_dichotomy c
