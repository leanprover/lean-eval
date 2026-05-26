# `conway_knot_not_smoothly_slice`

The Conway knot is not smoothly slice

- Problem ID: `conway_knot_not_smoothly_slice`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Lisa Piccirillo, *The Conway knot is not slice*, Annals of Mathematics 191 (2020). Resolves the last remaining case in the classification of slice knots through 12 crossings. The Conway knot has trivial Alexander polynomial so is topologically slice (Freedman), while Piccirillo's theorem rules out smooth sliceness — pairs with `conway_knot_topologically_slice` for an explicit, low-crossing-number witness to the smooth/topological gap (earlier witnesses such as Akbulut-Matveyev's Whitehead doubles existed).
- Source: https://arxiv.org/abs/1808.02923
- Informal solution: Piccirillo's strategy: construct a knot K' having the same 0-trace as the Conway knot. The trace-embedding argument then transfers sliceness — if the Conway knot were smoothly slice, K' would be too. Compute Rasmussen's s-invariant of K' (a smooth slice obstruction, via Khovanov homology / Lee's perturbation); show s(K') != 0; conclude both K' and the Conway knot are not smoothly slice. Note that the standard smooth slice obstructions s and tau both vanish on the Conway knot itself, which is why the detour through K' is needed.

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
