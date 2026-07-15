# `conway_knot_topologically_slice`

The Conway knot is topologically slice

- Problem ID: `conway_knot_topologically_slice`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Freedman's theorem applied to the Conway knot 11n34, whose Alexander polynomial is trivial. The proof requires Freedman's full topological surgery machinery in dimension four; this is genuinely hard. Pairs with `conway_knot_not_smoothly_slice` (Piccirillo) to give the celebrated smooth/topological dichotomy for a specific named knot.
- Source: Freedman, *The topology of four-dimensional manifolds*, J. Diff. Geom. 17 (1982). See also Freedman-Quinn, *Topology of 4-Manifolds*, Princeton 1990.
- Informal solution: Compute the Alexander polynomial of the Conway knot from a Seifert matrix and verify Delta(t) = 1. Apply Freedman's theorem: every knot in S^3 with Alexander polynomial 1 bounds a locally flat topological disk in B^4. Construct the resulting locally flat disk image inside R^3 x [0, infty) and verify the local flatness condition pointwise.

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
