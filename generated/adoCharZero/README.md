# `adoCharZero`

Ado's theorem in characteristic zero

- Problem ID: `adoCharZero`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every finite-dimensional Lie algebra L over a characteristic-zero field K admits a faithful finite-dimensional representation. The representation is required to be given as an injective K-linear Lie homomorphism from L to the commutator Lie algebra of endomorphisms of a finite-dimensional K-vector space. The arbitrary-characteristic `adoIwasawa` entry subsumes this statement; this separate entry records the characteristic-zero proof milestone.
- Source: Classical Ado theorem; W. Fulton and J. Harris, Representation Theory: A First Course, Appendix E. See also the Tau Ceti Ado–Iwasawa roadmap, https://github.com/TauCetiProject/TauCetiRoadmap/pull/102.
- Informal solution: Construct a faithful nilrepresentation of the center and extend it through an ideal flag in the solvable radical using derivation-stable cofinite ideals of universal enveloping algebras. Extend across a Levi complement, retaining a representation whose kernel meets the center trivially. Finally take its direct sum with the adjoint representation, whose kernel is the center; the direct sum is faithful.

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
