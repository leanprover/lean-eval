# `aspherical_integer_homology_four_sphere`

Existence of an aspherical integer homology 4-sphere

- Problem ID: `aspherical_integer_homology_four_sphere`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Resolves [Kir97, Problem 4.17]: is there a closed aspherical 4-manifold that is an integer homology 4-sphere? Tschantz constructed such manifolds; they even admit metrics of non-positive curvature. We bundle a closed topological 4-manifold and ask for it to be aspherical (all higher homotopy groups vanish) and to have the integral singular homology of S⁴ in every degree.
- Source: J. G. Ratcliffe and S. T. Tschantz, *On the Davis hyperbolic 4-manifold*, Topology Appl. 111 (2001); see also the discussion of [Kir97, Problem 4.17] in the K3 problem list. Earlier, F. Luo constructed an aspherical rational homology 4-sphere (1988).
- Informal solution: No formalization is feasible today: Mathlib has no construction of aspherical 4-manifolds, no hyperbolic geometry in dimension 4, and nothing resembling the Davis/Tschantz manifolds. The intended witness is a closed hyperbolic-flavoured 4-manifold whose fundamental group is a 4-dimensional duality group with the integral homology of S⁴.

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
