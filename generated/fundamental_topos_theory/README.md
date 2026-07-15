# `fundamental_topos_theory`

Fundamental theorem of topos theory

- Problem ID: `fundamental_topos_theory`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: The slice category E/X of an elementary topos E is again an elementary topos. The trusted helper IsTopos (non-hole) bundles finite limits + cartesian-closed (CartesianMonoidalCategory + MonoidalClosed) + a subobject classifier. Mathlib has finite limits and cartesian-monoidal structure on Over X and a HasSubobjectClassifier class, but neither MonoidalClosed (Over X) (the locally-cartesian-closed upgrade) nor HasSubobjectClassifier (Over X). Candidate from §54 of the Knill survey.
- Source: F. W. Lawvere & M. Tierney (elementary topos, 1970); see S. Mac Lane & I. Moerdijk, *Sheaves in Geometry and Logic*, IV.7. Knill, *Some fundamental theorems in mathematics*, §54.
- Informal solution: Reconstruct the three topos structures on E/X from those on E. Finite limits in the slice come from the comma-category construction (already in Mathlib). Cartesian closedness is the locally-cartesian-closed upgrade: the pullback functor f* : E/Y → E/X has a right adjoint Π_f (dependent product), built from exponentials in E; this gives internal homs in E/X. The subobject classifier of E/X is (Ω × X → X): a subobject of (A → X) is classified by composing A's characteristic map with the projection. Verifying the pullback/universal properties (Mac Lane–Moerdijk IV.7) is the substantive work.

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
