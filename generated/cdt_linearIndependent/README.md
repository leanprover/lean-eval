# `cdt_linearIndependent`

Linear independence results of Calegari–Dimitrov–Tang

- Problem ID: `cdt_linearIndependent`
- Test Problem: no
- Submitter: Junyan Xu
- Source: https://arxiv.org/abs/2408.15403
- Informal solution: See Figure 1.3.0. 'Leitfaden: paths to Theorems A and C' for a dependency graph of the results. The dotted lines indicates that there are two alternate paths to Theorems A and C, either through § 6 (by multivariable methods, based on measure concentration) or § 7 (by single variable methods, based on some Arakelov theory and Bost’s inequality on evaluation heights). Arithmetic holonomy bounds are ultimately the main concern of this paper.

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
