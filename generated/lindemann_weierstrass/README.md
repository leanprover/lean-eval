# `lindemann_weierstrass`

The Lindemann–Weierstrass theorem

- Problem ID: `lindemann_weierstrass`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: If x₁,…,xₙ ∈ ℂ are algebraic over ℚ and ℚ-linearly independent, then e^{x₁},…,e^{xₙ} are algebraically independent over ℚ. Mathlib has AlgebraicIndependent and the analytic scaffolding (LindemannWeierstrass namespace in AnalyticalPart.lean) but not the theorem. No new definitions needed. Candidate from §55 of the Knill survey.
- Source: F. Lindemann (1882); K. Weierstrass (1885). Knill, *Some fundamental theorems in mathematics*, §55.
- Informal solution: The Hermite–Lindemann–Weierstrass argument. Reduce algebraic independence of the e^{xᵢ} to: for distinct algebraic exponents β₁,…,β_m and nonzero algebraic coefficients, ∑ cⱼ e^{βⱼ} ≠ 0. Symmetrize over the Galois conjugates to get rational (then integer) coefficients, and bound the resulting nonzero algebraic integer below (it is a nonzero norm) while bounding it above using Hermite's polynomial-integral construction ∫ e^{-t}f(t)dt with f built from the βⱼ to large power p; the p! divisibility makes the main term a nonzero integer and the tail < 1, a contradiction. Mathlib's AnalyticalPart provides the integral estimates.

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
