# `annulus_theorem_dim_four`

The Annulus Theorem in dimension 4 (Quinn)

- Problem ID: `annulus_theorem_dim_four`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The closed region between two disjoint, nested, locally flat embedded 3-spheres in ℝ⁴ is homeomorphic to S³ × [0,1]. This is the four-dimensional annulus theorem, of an entirely different difficulty from the n ≥ 5 case: it was settled by Quinn (1982), building on Freedman's topology of 4-manifolds. Same infrastructure as annulus_theorem_high_dim; local flatness is essential, and 'inside' is defined via bounded complementary components rather than the (absent) Jordan–Brouwer theorem.
- Source: F. Quinn, *Ends of maps III: dimensions 4 and 5*, J. Differential Geom. 17 (1982), building on M. H. Freedman, *The topology of four-dimensional manifolds*, J. Differential Geom. 17 (1982).
- Informal solution: No formalization is feasible today: this needs Freedman–Quinn 4-dimensional topology (Casson handles, the disk embedding theorem), none of which is in Mathlib, on top of the missing Jordan–Brouwer separation and locally-flat-embedding theory.

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
