# `conway_knot_not_smoothly_slice`

The Conway knot is not smoothly slice

- Problem ID: `conway_knot_not_smoothly_slice`
- Test Problem: no
- Submitter: Kim Morrison
- Holes (2): `LeanEval.KnotTheory.conwayKnot_isSimple` (theorem), `LeanEval.KnotTheory.conway_knot_not_smoothly_slice` (theorem)
- Notes: Lisa Piccirillo, *The Conway knot is not slice*, Annals of Mathematics 191 (2020). Resolves the last remaining case in the classification of slice knots through 12 crossings. The Conway knot has trivial Alexander polynomial so is topologically slice (Freedman), while Piccirillo's theorem rules out smooth sliceness — pairs with `conway_knot_topologically_slice` for an explicit, low-crossing-number witness to the smooth/topological gap (earlier witnesses such as Akbulut-Matveyev's Whitehead doubles existed). Two holes: `conwayKnot_isSimple` asks the solver to certify that the fixed 78-vertex braid-closure polyline is an embedded simple closed curve (a finite check, e.g. over an exact integer model), and `conway_knot_not_smoothly_slice` is Piccirillo's theorem proper; `conwayKnot` itself is trusted, `sorry`-free data. We'd like to thank Lorenzo Luccioli (using Aristotle) for identifying a mis-formalization of the notion of smoothly slice in an earlier version of this problem.
- Source: https://arxiv.org/abs/1808.02923
- Informal solution: Piccirillo's strategy: construct a knot K' having the same 0-trace as the Conway knot. The trace-embedding argument then transfers sliceness — if the Conway knot were smoothly slice, K' would be too. Compute Rasmussen's s-invariant of K' (a smooth slice obstruction, via Khovanov homology / Lee's perturbation); show s(K') != 0; conclude both K' and the Conway knot are not smoothly slice. Note that the standard smooth slice obstructions s and tau both vanish on the Conway knot itself, which is why the detour through K' is needed.

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
