# `schoenflies`

Schoenflies theorem

- Problem ID: `schoenflies`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: §48 of Knill's 'Some Fundamental Theorems in Mathematics'. Strong form: every Jordan curve in the plane is the image of the unit circle under some self-homeomorphism of ℝ². This is the faithful encoding of Knill's prose statement 'each complementary region is homeomorphic to the open disk' — which as literally written is false for the unbounded region (homeomorphic to ℝ² ∖ closedBall 0 1, fundamental group ℤ, not simply connected). The strong form implies the bounded region is homeomorphic to the open disk. Mathlib has Metric.sphere, EuclideanSpace, and Homeomorph, but no Schoenflies theorem (`grep -ri 'schoenflies' Mathlib/`: no hits), no Jordan curve theorem, no invariance-of-domain machinery in a form that would discharge it. Stateable with zero new definitions.
- Source: A. M. Schoenflies, *Beiträge zur Theorie der Punktmengen III*, Math. Annalen 62 (1906) (first proof, with gaps); rigorous proofs by L. Antoine (1921), L. E. J. Brouwer (1909–10). Listed as §48 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). No formalization found in any major prover.
- Informal solution: Classical proof: (i) the Jordan curve theorem gives the inside and outside regions; (ii) Riemann mapping for the bounded inside extends to a homeomorphism of the closed disk by Carathéodory's theorem on prime ends; (iii) a parallel construction handles the outside; (iv) the two homeomorphisms patch along the curve to a homeomorphism of ℝ².

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

Write your solution in `Submission.lean` and any additional local modules under
`Submission/`.

Participants may use declarations from the existing Mathlib imports. Broadening
the import header (especially to `import Mathlib`) can change elaboration of the
fixed statement; any added import must leave `lake build Solution` green. Helper
code not available through compatible imports must be inlined into the workspace.

Multi-file submissions are allowed through `Submission.lean` and additional local
modules under `Submission/`.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
