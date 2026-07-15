# `regular_value_ae`

Sard's regular-value corollary

- Problem ID: `regular_value_ae`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a smooth f : ℝᵐ → ℝ, almost every c ∈ ℝ is a regular value (every point of f⁻¹(c) has nonzero derivative). The measure-theoretic heart of the regular-value form of Sard's theorem; the main critical-set-null Sard theorem is a separate lean-eval problem (§125 main). Trusted helper IsRegularValue (non-hole). Mathlib has the equal-dimension Jacobian lemma and Hausdorff-dimension corollaries but not the general critical-values-null statement. Candidate from §125 of the Knill survey (additional 1).
- Source: A. Sard, *The measure of the critical values of differentiable maps*, Bull. AMS 48 (1942); A. P. Morse (1939). Knill, *Some fundamental theorems in mathematics*, §125.
- Informal solution: Apply Sard's theorem with target dimension n = 1: the set of critical values of f (images of points where df = 0) has Lebesgue measure zero. A value c is regular iff it is not a critical value, so the regular values are the complement of a null set, i.e. almost every c is regular. Reduces to the main Sard theorem (critical set null) specialized to real-valued f.

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
