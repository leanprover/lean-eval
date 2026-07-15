import ChallengeDeps
import Submission

open LeanEval.Dynamics.MandelbrotBoundary
open Function MeasureTheory

theorem mandelbrot_boundary_dimh :
    dimH (frontier Mandelbrot) = 2 := by
  exact Submission.mandelbrot_boundary_dimh
