# `adoIwasawa`

Ado–Iwasawa theorem over an arbitrary field

- Problem ID: `adoIwasawa`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every finite-dimensional Lie algebra L over an arbitrary field K admits a faithful finite-dimensional representation. The representation is required to be given as an injective K-linear Lie homomorphism from L to the commutator Lie algebra of endomorphisms of a finite-dimensional K-vector space. This entry subsumes `adoCharZero`; both remain separate problem-list entries because the characteristic-zero proof is a distinct milestone.
- Source: K. Iwasawa, On the representation of Lie algebras, Japanese Journal of Mathematics 19 (1948), 405–426. See also the Tau Ceti Ado–Iwasawa roadmap, https://github.com/TauCetiProject/TauCetiRoadmap/pull/102.
- Informal solution: Split on the characteristic of K. In characteristic zero, apply Ado's theorem. In characteristic p, use PBW and central p-polynomials to make the universal enveloping algebra finite over a central commutative subalgebra. A generalized Krull intersection argument produces a finite-dimensional quotient that remains injective on L; its left-regular action is the required faithful representation.

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
