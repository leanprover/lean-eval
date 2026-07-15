# `poincare_bendixson`

Poincaré–Bendixson theorem

- Problem ID: `poincare_bendixson`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Planar trichotomy for the forward integral curve γ of a C¹ autonomous vector field F : ℝ² → ℝ². Either the forward orbit is unbounded; the ω-limit set ⋂ s, closure (γ '' Ici s) contains an equilibrium of F; or the ω-limit set equals the range of a non-constant periodic integral curve. The bounded branch uses 'ω-limit contains an equilibrium' rather than pointwise convergence (planar orbits may accumulate on continua of equilibria or polycycles). Case 3 requires F (β 0) ≠ 0 to exclude a constant equilibrium curve; the conclusion is a non-constant periodic orbit, not a limit cycle in the strict sense. §63 of Knill's 'Some Fundamental Theorems in Mathematics'.
- Source: H. Poincaré, *Mémoire sur les courbes définies par une équation différentielle*, Journal de Mathématiques 7 (1881), 8 (1882), 1 (1885), 2 (1886); I. Bendixson, *Sur les courbes définies par des équations différentielles*, Acta Mathematica 24 (1901), 1-88. Listed as §63 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). The Isabelle/HOL/AFP entry by Fabian Immler and Yong Kiam Tan (https://www.isa-afp.org/entries/Poincare_Bendixson.html) uses John Harrison's Jordan curve theorem.
- Informal solution: Classical proof: assume the forward orbit is bounded and the ω-limit set contains no equilibrium. Pick a regular point p of the ω-limit set and a transverse arc Σ at p. The first-return map P : Σ → Σ along the flow is well-defined and monotone in the natural linear order on Σ; the orbit's intersections with Σ form a monotone sequence converging to p. Combined with the Jordan curve theorem (a closed orbit Γ separates ℝ² into bounded interior and unbounded exterior, and trajectories cannot escape across Γ), this forces the ω-limit set to be exactly the range of a periodic integral curve through p. The non-degeneracy F (β 0) ≠ 0 follows from p being a regular point.

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
