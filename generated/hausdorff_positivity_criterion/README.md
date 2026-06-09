# `hausdorff_positivity_criterion`

The Hausdorff positivity (complete-monotonicity) criterion

- Problem ID: `hausdorff_positivity_criterion`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A multi-indexed real sequence is a positive moment configuration on the unit cube Iᵈ (realized by a positive finite measure) iff it is completely monotone: all iterated backward differences are nonnegative, (Δᵏa)ₙ ≥ 0 for all k ≤ n. Shares the §115 trusted scaffolding (cube, monomial, momentOf, multiChoose, diff, IsPositiveMomentConfiguration). Not in Mathlib (no completely-monotone sequences / Hausdorff moment problem). Companion candidate from §115 of the Knill survey.
- Source: F. Hausdorff, *Summationsmethoden und Momentfolgen I, II*, Math. Z. 9 (1921). Knill, *Some fundamental theorems in mathematics*, §115.
- Informal solution: Classical Hausdorff moment problem (positive case). Forward: if aₙ = ∫ xⁿ dμ with μ ≥ 0, then (Δᵏa)ₙ = ∫ x^{n−k}(1−x)ᵏ dμ ≥ 0 since the integrand is nonnegative on the cube. Converse (complete monotonicity ⇒ positive realizing measure): the Bernstein/Hausdorff construction — the nonnegative numbers C(n,k)(Δᵏa)ₙ define positive masses on a refining sequence of cube partitions, giving a consistent family of positive measures of bounded total mass a_0; take a weak-* limit (Helly/Banach–Alaoglu + Riesz) to get a finite positive measure μ on Iᵈ with the prescribed moments.

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
