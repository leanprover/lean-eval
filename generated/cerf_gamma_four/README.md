# `cerf_gamma_four`

Cerf's theorem: every self-diffeomorphism of S3 is smoothly isotopic to a linear isometry

- Problem ID: `cerf_gamma_four`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Cerf's 1968 theorem, the X = point (unparameterized) case of the Smale conjecture. Stated as the existence of a smooth isotopy [0,1] x S3 -> S3 from f to a linear isometry, witnessed by a smooth slice-inverse to encode the diffeomorphism property of each slice without needing a topology on Diffeomorph.
- Source: J. Cerf, Sur les diffeomorphismes de la sphere de dimension trois, Lecture Notes in Mathematics 53, Springer (1968).
- Informal solution: Cerf's original proof uses pseudo-isotopy theory: a self-diffeomorphism of S3 extends to a pseudo-isotopy of D4, and Cerf's theorem on the triviality of pi_0 of the pseudo-isotopy space in dimension 4 implies the extension is isotopic to a genuine isotopy. Hatcher (1983) reproved this as a corollary of the full Smale conjecture using configurations of 2-spheres.

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
