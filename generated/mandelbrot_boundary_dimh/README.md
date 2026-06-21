# `mandelbrot_boundary_dimh`

Hausdorff dimension of the Mandelbrot boundary (Shishikura)

- Problem ID: `mandelbrot_boundary_dimh`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Shishikura's theorem: the boundary of the Mandelbrot set has Hausdorff dimension 2. The Mandelbrot set is the bounded critical-orbit locus of the quadratic family T_c(z) = z² + c, and dimH is mathlib's MeasureTheory.dimH. Mathlib has dimH, Hausdorff measure, frontier, and Function.iterate, but no complex-dynamics, Mandelbrot/Julia set, or parabolic-implosion machinery, and no Shishikura theorem. Listed as §260 of the Knill survey.
- Source: M. Shishikura, The Hausdorff dimension of the boundary of the Mandelbrot set and Julia sets, Ann. of Math. 147 (1998). Listed as §260 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). Knill, §260.
- Informal solution: Shishikura proves it via parabolic bifurcation and the theory of parabolic implosion: near parameters with a parabolic cycle, the technique of fattening Cantor repellers and computing the limiting hyperbolic dimension shows that the bifurcation locus accumulates sets of hyperbolic dimension arbitrarily close to 2 on the Mandelbrot boundary. Since the boundary sits in ℂ ≅ ℝ², its dimension is at most 2, and the construction forces it to be exactly 2 (with full Hausdorff dimension at a generic boundary parameter). None of this — parabolic implosion, Lavaurs maps, hyperbolic dimension, or even the Mandelbrot set — exists in Mathlib, so no formalization is currently feasible.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
