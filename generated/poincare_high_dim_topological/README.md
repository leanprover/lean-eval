# `poincare_high_dim_topological`

Generalized topological Poincaré conjecture in dimensions ≥ 5 (Smale)

- Problem ID: `poincare_high_dim_topological`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For n ≥ 5, every Hausdorff n-manifold homotopy-equivalent to 𝕊ⁿ is homeomorphic to 𝕊ⁿ. Specialization to n ≥ 5 of mathlib's generalized `proof_wanted ContinuousMap.HomotopyEquiv.nonempty_homeomorph_sphere` in `Mathlib/Geometry/Manifold/PoincareConjecture.lean`. Stephen Smale 1961 (Bull. AMS 66, Ann. of Math. 74) originally for smooth M via the h-cobordism theorem; topological version completed by Newman 1966 and Connell 1967. Smale received the Fields Medal in 1966. Mathlib has the homotopy-equiv / homeo / ChartedSpace scaffolding but no h-cobordism theorem, no handle decompositions, and no Poincaré conjecture in any dimension.
- Source: S. Smale, Generalized Poincaré's conjecture in dimensions greater than four, Ann. of Math. 74 (1961), 391-406. Topological case: M. H. A. Newman, The engulfing theorem for topological manifolds, Ann. of Math. 84 (1966) and E. H. Connell, A topological h-cobordism theorem for n ≥ 5, Illinois J. Math. 11 (1967). Specialization of `proof_wanted ContinuousMap.HomotopyEquiv.nonempty_homeomorph_sphere` in Mathlib/Geometry/Manifold/PoincareConjecture.lean.
- Informal solution: Smale's smooth proof: a smooth homotopy n-sphere M (n ≥ 5) bounds a smooth contractible (n+1)-manifold W via Whitehead's theorem and a Mayer-Vietoris computation; apply the h-cobordism theorem (Smale's main contribution) to W minus two small balls to conclude W ≃ D^{n+1}, hence M = ∂W ≃ S^n smoothly. The topological version (Newman/Connell) replaces the h-cobordism step with the topological engulfing theorem and a topological h-cobordism theorem, proving the same conclusion without the smoothness hypothesis. The dim ≥ 5 hypothesis is crucial: it allows the Whitney trick to remove pairs of intersections, which fails in dim 4 (requiring Casson handles, Freedman 1982) and below.

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
