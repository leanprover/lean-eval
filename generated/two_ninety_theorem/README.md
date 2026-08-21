# `two_ninety_theorem`

The 290 theorem

- Problem ID: `two_ninety_theorem`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Bolton Bailey/Project Numina
- Notes: The 290 theorem (Bhargava–Hanke): a positive-definite integral quadratic form represents every positive integer if it represents a particular collection of 29 critical numbers below 290.
- Source: M. Bhargava, J. Hanke, Universal quadratic forms and the 290-theorem, preprint (2011). See also https://en.wikipedia.org/wiki/15_and_290_theorems
- Informal solution: The proof combines advances in the escalation method and bounds on Fourier coefficients of weight 2 theta functions. It also uses a trick to allow the analysis to focus mainly on quaternary forms.

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
