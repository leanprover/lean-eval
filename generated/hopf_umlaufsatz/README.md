# `hopf_umlaufsatz`

The Hopf Umlaufsatz (theorem of turning tangents)

- Problem ID: `hopf_umlaufsatz`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A positively oriented simple closed unit-speed plane curve has total signed curvature 2π. Trusted helpers (signedArea, signedCurvature, totalCurvature, IsPositiveSimpleClosedUnitSpeedCurve, IsTangentAngleLift, …) are non-holes. Mathlib has no turning-tangents theorem. Candidate from §170 of the Knill survey.
- Source: H. Hopf, *Über die Drehung der Tangenten...*, Compositio Math. 2 (1935). Knill, §170.

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
