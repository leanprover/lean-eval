# `poincare_4d_topological`

4D topological Poincaré conjecture (Freedman)

- Problem ID: `poincare_4d_topological`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every Hausdorff 4-manifold homotopy-equivalent to 𝕊⁴ is homeomorphic to 𝕊⁴. Specialization to n = 4 of mathlib's generalized `proof_wanted ContinuousMap.HomotopyEquiv.nonempty_homeomorph_sphere` in `Mathlib/Geometry/Manifold/PoincareConjecture.lean`. Michael Freedman's 1982 theorem (J. Differential Geom. 17), Fields Medal 1986. Proof uses Casson handles and the Bing-topology infinite-process construction. The corresponding smooth 4D Poincaré conjecture (every smooth homotopy 4-sphere is diffeomorphic to S⁴) remains famously OPEN and is not included here. Mathlib has the homotopy-equiv / homeo / ChartedSpace scaffolding but no Casson handles or Freedman's theorem.
- Source: M. H. Freedman, The topology of four-dimensional manifolds, J. Differential Geom. 17 (1982), 357-453. Specialization of `proof_wanted ContinuousMap.HomotopyEquiv.nonempty_homeomorph_sphere` in Mathlib/Geometry/Manifold/PoincareConjecture.lean.
- Informal solution: Freedman's main theorem: every topological 4-manifold homotopy equivalent to a topological model is homeomorphic to it, provided one can construct topological Casson handles. The construction of Casson handles is via a Bing-style limiting process (countably many handle additions, infinite tower of 2-handles) that produces a topological — but not smooth — 4-ball. Applying this to a homotopy 4-sphere M, one writes M as the union of two 2-handlebodies along their boundary, replaces handles with Casson handles, and assembles a homeomorphism to S⁴. The smooth analogue is open because Casson handles need not be smoothly standard (Donaldson's invariants distinguish smooth structures in dim 4).

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
