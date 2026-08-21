# `annals_dirichlet_weyl_bound`

The Weyl bound for Dirichlet L-functions of cube-free conductor

- Problem ID: `annals_dirichlet_weyl_bound`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: annals
- Submitter: Thomas Browning
- Notes: The proof binders `hq` and `hχ` are named `_hq` and `_hχ` here. This is alpha-equivalent and suppresses unused-variable warnings in the generated `Solution.lean` delegation.
- Source: I. Petrow and M. P. Young, `The Weyl bound for Dirichlet L-functions of cube-free conductor`, Annals of Math, 192 (2) 2020. Statement taken from https://github.com/ImperialCollegeLondon/AnnalsChallenge (v1.0.0, e32eb14), AnnalsChallenge/AnnalsOfMathematics/2020-192-2-DirichletWeylBound.lean

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
