# `brauer_fowler`

Brauer–Fowler theorem

- Problem ID: `brauer_fowler`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The order of a finite nonabelian simple group is bounded by a function of the order of any involution centralizer. R. Brauer and K. A. Fowler, 'On groups of even order', Ann. of Math. 62 (1955), 565-583. A foundational result of the CFSG programme: it reduced (in principle) the classification of finite simple groups to the analysis of involution centralizers — the strategy used by Brauer–Suzuki, Brauer–Suzuki–Wall, Janko, and many others to identify sporadic simple groups. Statement uses only Mathlib (IsSimpleGroup, Nat.card, Subgroup.centralizer, orderOf), no new definitions.
- Source: R. Brauer and K. A. Fowler, On groups of even order, Ann. of Math. (2) 62 (1955), 565-583. https://doi.org/10.2307/1970080
- Informal solution: Counting argument. For an involution t in a finite simple group G with C := |C_G(t)|, every pair of involutions a, b generates a dihedral subgroup ⟨a,b⟩ of order 2k for some k ≥ 1; the product ab has order k. Use the class equation and orbit-counting on conjugates of t to show that |G| divides (2C^2)! or a similar explicit factorial of a polynomial in C — any such bound furnishes the required f.

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
