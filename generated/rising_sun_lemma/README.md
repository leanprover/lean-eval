# `rising_sun_lemma`

Riesz's rising sun lemma

- Problem ID: `rising_sun_lemma`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every continuous real function on a compact interval has the rising-sun property: the shadow set is open, empty iff the function is antitone, else a disjoint union of open intervals with f(c_n) ≤ f(d_n). Trusted helpers (risingSunSet, HasRisingSunDecomposition, HasRisingSunProperty) are non-holes. Mathlib has the monotone-a.e.-differentiable consequence but not the rising-sun lemma. Candidate from §163 of the Knill survey.
- Source: F. Riesz (1932). Knill, §163.

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
