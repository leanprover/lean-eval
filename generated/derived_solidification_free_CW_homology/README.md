# `derived_solidification_free_CW_homology`

Derived solidification of free CW complexes (light condensed mathematics)

- Problem ID: `derived_solidification_free_CW_homology`
- Test Problem: no
- Submitter: Dagur Asgeirsson
- Holes (12): `LightCondensed.Solid.solidification` (def), `LightCondensed.Solid.solidification_additive` (theorem), `LightCondensed.Solid.solidificationAdjunction` (def), `LightCondensed.Solid.derivedSolidification` (def), `LightCondensed.Solid.derivedSolidificationCounit` (def), `LightCondensed.Solid.derivedSolidification_isLeftDerivedFunctor` (theorem), `LightCondensed.Solid.derivedSolidificationAdjunction` (def), `LightCondensed.Solid.derivedSolidificationFreeCWFunctor` (def), `LightCondensed.Solid.derivedSolidificationFreeCWFunctorSpec` (def), `LightCondensed.Solid.derivedSolidification_free_CW_derivedNatIso` (def), `LightCondensed.Solid.derivedSolidification_free_CW_homologyIso` (def), `LightCondensed.Solid.derivedSolidification_free_CW_homology` (theorem)
- Notes: Extracted from the LeanCondensed project, which develops Clausen–Scholze light condensed mathematics in Lean. The trusted part of the file defines light solid abelian groups (a light condensed abelian group is solid if 1 - shift acts invertibly on internal homs out of P = ℤ[ℕ∪{∞}]/ℤ[∞]) and shows the category of solid objects is abelian with an exact inclusion into light condensed abelian groups. The holes ask for the solidification functor with its adjunction, the derived solidification functor characterized as the total left derived functor of degreewise solidification, the derived adjunction, the CW-functor package identifying derived solidification of free light condensed abelian groups on CW complexes, and finally the comparison theorem: naturally in a CW complex X, the derived inclusion of the derived solidification of the free light condensed abelian group ℤ[X] is isomorphic in the derived category of light condensed abelian groups to the integral singular chains of X (homological degree n placed in cohomological degree -n), hence its homology is integral singular homology. The adjunctions, derived-functor property, and CW-functor specification pin the data holes down up to natural isomorphism, so the final theorem has its intended content.
- Source: https://github.com/dagurtomas/LeanCondensed (LeanCondensed/Projects/DerivedSolidCWHomology.lean); D. Clausen and P. Scholze, lectures on analytic stacks and light condensed mathematics.; P. Scholze, Lectures on Condensed Mathematics, https://arxiv.org/pdf/2605.03658
- Informal solution: Solidification exists by a light-condensed adjoint functor theorem (the solid objects form a reflective subcategory closed under limits and colimits). Derived solidification is the total left derived functor, which exists since the category of solid abelian groups has a compact projective generator. The natural derived comparison is the chain-level form of the same result: for a CW complex X, derived solidification of ℤ[X] identifies with the integral singular chains of X in the derived category of light condensed abelian groups; taking homology gives the pointwise statement. For the comparison: see Example 6.5 in https://arxiv.org/pdf/2605.03658

Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the
trusted benchmark and fixed by the repository.

This is a multi-hole problem: the challenge declares multiple `def`s,
`instance`s, and/or `theorem`s as `sorry`. Fill all of them in
`Submission.lean` (under `namespace Submission`) for comparator to accept
your solution.

Participants may use Mathlib freely. Any helper code not already available in
Mathlib must be inlined into the submission workspace.

`lake test` runs comparator for this problem. The command expects a comparator
binary in `PATH`, or in the `COMPARATOR_BIN` environment variable.
