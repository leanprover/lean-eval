# `classification_finite_simple_groups`

The classification of finite simple groups

- Problem ID: `classification_finite_simple_groups`
- Group: `formalization-evaluation`
- Status: `active`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Kim Morrison
- Notes: Every finite simple group is isomorphic to a cyclic group of prime order, an alternating group Aₙ with n ≥ 5, a group of Lie type, or one of the twenty-six sporadic groups. The list is the Tau Ceti project's TauCeti.CFSGIndex, and the statement is TauCeti.ClassificationStatement spelled out. The Lie-type groups are explicit constructions (the derived subgroup of the fixed points of a Steinberg endomorphism, modulo its centre), and the sporadic groups are given by explicit finite presentations; the problem inherits the correctness of those definitions from Tau Ceti. Only the direction 'every finite simple group is on the list' is required: finiteness, simplicity and irredundancy of the listed groups are not part of the statement.
- Source: D. Gorenstein, R. Lyons and R. Solomon, The Classification of the Finite Simple Groups (AMS Mathematical Surveys and Monographs 40, 1994–); M. Aschbacher, R. Lyons, S. D. Smith and R. Solomon, The Classification of Finite Simple Groups: Groups of Characteristic 2 Type (AMS, 2011). Statement: https://github.com/TauCetiProject/TauCeti/blob/main/TauCeti/GroupTheory/SpecificGroups/CFSG/Classification.lean

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
