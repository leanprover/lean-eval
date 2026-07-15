# `nonlinear_three_manifold_group`

A 3-manifold group with no faithful representation into GL(4, ℝ)

- Problem ID: `nonlinear_three_manifold_group`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Resolves [Kir97, Problem 3.33] (Thurston): does every finitely generated 3-manifold group admit a faithful representation into GL(4, ℝ)? The answer is no. Button exhibited closed graph manifolds whose fundamental groups have no faithful representation into GL(4, k) for any field k; here we state the negative answer over ℝ. A path-component of a topological 3-manifold is itself a closed 3-manifold, so connectedness need not be assumed.
- Source: J. O. Button, *Aspherical 3-manifold groups not in GL(4, k) for any field k*, arXiv:1404.4639 (2014). See the discussion of [Kir97, Problem 3.33] in the K3 problem list.
- Informal solution: No formalization is feasible today: Mathlib has no graph manifolds and none of the obstruction theory (the structure of 3-manifold groups, behaviour under JSJ decomposition) Button uses. The intended witness is a closed graph manifold whose fundamental group cannot embed in any GL(4, k).

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
