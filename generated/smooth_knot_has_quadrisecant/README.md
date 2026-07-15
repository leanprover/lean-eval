# `smooth_knot_has_quadrisecant`

Pannwitz–Kuperberg quadrisecant theorem

- Problem ID: `smooth_knot_has_quadrisecant`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every smooth knot that is not the unknot has a quadrisecant (a line meeting it in four points). Trusted helpers (IsSmoothKnot, IsUnknotted, HasQuadrisecant, …) are non-holes. Mathlib has no knot theory. The Fáry–Milnor total-curvature theorem of §161 is a separate lean-eval problem. Candidate from §161 of the Knill survey.
- Source: E. Pannwitz (1933); G. Kuperberg, *Quadrisecants of knots and links*, J. Knot Theory Ramif. 3 (1994). Knill, §161.

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
