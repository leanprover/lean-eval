# `weak_goldbach`

Weak Goldbach theorem

- Problem ID: `weak_goldbach`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Vasily Ilin
- Notes: Helfgott's weak (or ternary) Goldbach theorem: every odd natural number greater than 5 is a sum of three primes. The existential witnesses may repeat, as required by the least case 7 = 2 + 2 + 3. Mathlib has natural-number primality and the parity predicate `Odd`, but no ternary Goldbach theorem.
- Source: H. A. Helfgott, The ternary Goldbach conjecture is true, arXiv:1312.7748 (2013), https://arxiv.org/abs/1312.7748; H. A. Helfgott and D. J. Platt, Numerical Verification of the Ternary Goldbach Conjecture up to 8.875·10^30, Experimental Mathematics 22 (2013), 406–409, https://doi.org/10.1080/10586458.2013.831742.
- Informal solution: Apply the Hardy–Littlewood circle method to explicitly weighted exponential sums over the primes. Helfgott's major-arc estimates produce a positive main term, while optimized smoothing, a large sieve for primes, and new minor-arc estimates make the total error smaller for every odd N ≥ 10^27. Helfgott and Platt's prime-ladder computation verifies the ternary conjecture through 8.875·10^30, covering the remaining finite range.

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
