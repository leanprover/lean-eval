# `baer_suzuki`

Baer–Suzuki theorem

- Problem ID: `baer_suzuki`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: An element x of a finite group G lies in the p-core O_p(G) iff every pair (x, x^g) of conjugates generates a p-group. R. Baer, 'Engelsche Elemente Noetherscher Gruppen', Math. Ann. 133 (1957), 256-270 (the case p = 2); M. Suzuki, 'Finite groups in which the centralizer of any element of order 2 is 2-closed', Ann. of Math. 82 (1965), 191-212 (general p). A standard tool in CFSG-era local analysis, used together with the Bender method and signalizer functor theory. Introduces a small Defs/PCore.lean defining the p-core O_p(G) as the supremum of normal p-subgroups (Mathlib has no `pCore` operation).
- Source: R. Baer, Engelsche Elemente Noetherscher Gruppen, Math. Ann. 133 (1957), 256-270; M. Suzuki, Finite groups in which the centralizer of any element of order 2 is 2-closed, Ann. of Math. (2) 82 (1965), 191-212.
- Informal solution: Forward: O_p(G) is a normal p-subgroup, so it contains both x and x^g and hence their generated subgroup, which is therefore a p-group. Reverse (the deep direction): assume by minimal counterexample. The hypothesis ⟨x, x^g⟩ a p-group for all g (taking g = 1) forces x to be a p-element. Suzuki's original proof passes to a faithful representation and exploits a transitivity argument on the set of conjugates of x. The cleanest modern proof (Aschbacher, *Finite Group Theory*, §31) routes through the lemma that if every two conjugates of x generate a p-group, then ⟨x^G⟩ — the normal closure of x — is itself a p-group, hence contained in O_p(G).

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
