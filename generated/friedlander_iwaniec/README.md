# `friedlander_iwaniec`

Friedlander–Iwaniec theorem

- Problem ID: `friedlander_iwaniec`
- Group: `formalization-evaluation`
- Status: `draft`
- Visible: yes
- Statement Revision: 1
- Tags: none
- Submitter: Bolton Bailey/Project Numina
- Notes: The Friedlander–Iwaniec theorem: there are infinitely many primes of the form `a² + b⁴`.
- Source: Friedlander, John, and Henryk Iwaniec. “The Polynomial X² + Y⁴ Captures Its Primes.” Annals of Mathematics, vol. 148, no. 3, 1998, pp. 945–1040. JSTOR, https://doi.org/10.2307/121034.
- Informal solution: Friedlander and Iwaniec develop a sieve for primes that, unlike classical sieves, can detect primes in a sequence as thin as `a² + b⁴`. The crux is establishing sum-estimates for a bilinear form involving a Möbius-function-like term and a term for counting representations of a number of the `a² + b⁴` form.

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
