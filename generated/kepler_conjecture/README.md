# `kepler_conjecture`

Kepler conjecture (optimal sphere packing in ℝ³)

- Problem ID: `kepler_conjecture`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The optimal sphere-packing density in three dimensions equals π / √18, the density of the face-centred-cubic packing. The packing is taken over arbitrary (not necessarily lattice) sets of centres in ℝ³, with density defined via the limsup of the fraction of B_R(0) covered by the union of unit balls. §96 of Knill's *Some Fundamental Theorems in Mathematics*. The d = 8 (Viazovska) sphere-packing case is being formalised separately in `thefundamentaltheor3m/Sphere-Packing-Lean` and is excluded from this submission per the dedicated-external-project rule.
- Source: Kepler conjecture 1611 (J. Kepler, *Strena seu de Nive Sexangula*); proof T. Hales, 'A proof of the Kepler conjecture', Ann. of Math. (2) 162 (2005) 1065–1185; formal verification in HOL Light + Isabelle by the Flyspeck project (T. Hales et al., completed August 2014), Forum Math. Pi 5 (2017) e2. Wiedijk-1000 #209; listed as §96 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Hales's proof reduces the global density bound to a finite collection of local nonlinear inequalities on decomposition stars built from Voronoi–Delaunay data around each packing centre, then certifies these inequalities by interval arithmetic and linear programming over roughly 100 000 subproblems. The Flyspeck formalisation (HOL Light core + Isabelle/HOL for the LP component) discharged both the geometric reduction and the computational certificates. Mathlib has Lebesgue volume on `EuclideanSpace ℝ (Fin 3)`, ZLattice covolume, and limsup, but no packing density, no Voronoi/Delaunay machinery, no nonlinear-LP framework, and no Flyspeck-style certified interval arithmetic.

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
