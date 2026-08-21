# `boone_higman_embedding`

Boone–Higman theorem (easy direction)

- Problem ID: `boone_higman_embedding`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: If a finitely presented group G embeds in a simple group H that embeds in a finitely presented group K, then G has a solvable word problem — the 'if' half of the Boone–Higman characterisation. Trusted helper WordProblemSolvable (non-hole) via ComputablePred. Mathlib has finitely-presented/free/simple groups and computability but no word-problem notion or Boone–Higman theorem. The main Kuznetsov/Boone–Higman, Novikov, and Higman-infinite-simple statements of §122 are already in lean-eval. Candidate from §122 (additional 1).
- Source: W. W. Boone & G. Higman, *An algebraic characterization of groups with soluble word problem*, J. Austral. Math. Soc. 18 (1974). Knill, *Some fundamental theorems in mathematics*, §122.
- Informal solution: The easy direction. Embed G ↪ H ↪ K with H simple and K finitely presented. The word problem of K is recursively enumerable from its finite presentation (enumerate consequences of the relators). Words of G equal to 1 are those mapping to 1 in K (via the composite injection), which is r.e.; words not equal to 1 are detected through the simple group H: adjoining a nontrivial element as a relator collapses H, making 'w ≠ 1' also r.e. Both r.e. ⇒ decidable, so G's word problem is solvable. Uses the Kuznetsov/Boone–Higman recursively-enumerable-from-both-sides argument (r.e. equality from K's finite presentation, r.e. inequality from H simple), absent from Mathlib.

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
