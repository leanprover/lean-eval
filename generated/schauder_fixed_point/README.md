# `schauder_fixed_point`

Schauder fixed-point theorem

- Problem ID: `schauder_fixed_point`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §60 of Knill's 'Some Fundamental Theorems in Mathematics' (additional statement). The Banach-space generalization of Brouwer: every continuous self-map of a nonempty compact convex subset of a real Banach space has a fixed point. Mathlib has NormedAddCommGroup / NormedSpace / CompleteSpace and the Banach contraction principle (ContractingWith.exists_fixedPoint, strictly weaker), but no Schauder fixed-point theorem. SchauderBasis / GeneralSchauderBasis in mathlib are unrelated (about sequences spanning a Banach space, not fixed points). No open mathlib PR; the Sperner → Brouwer → Schauder dependency chain is partially in motion (Sperner partially landed, Brouwer in flight in #36770). Active downstream demand from the PDE community for Schauder / Schaefer / Leray–Schauder machinery (cf. Nelson Spence's 2026-03-06 Zulip thread). Stateable with zero new definitions.
- Source: J. Schauder, *Der Fixpunktsatz in Funktionalräumen*, Studia Mathematica 2 (1930), 171-180. Listed as §60 (additional statement 2) in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). No formalization found in mathlib4 or any open mathlib PR; Brouwer is in flight via https://github.com/leanprover-community/mathlib4/pull/36770.
- Informal solution: Standard proof: approximate the compact convex K by finite-dimensional convex polytopes K_n via ε-nets and the convex-hull construction; on each K_n apply Brouwer fixed-point to a continuous projection of f to get a fixed point x_n ∈ K_n; pass to a subsequence x_n → x (compactness of K), and verify f x = x using uniform continuity of f on the compact set K. The full argument depends on Brouwer's fixed-point theorem (the main classical input) and Mazur's theorem (the closed convex hull of a compact subset of a Banach space is compact, which uses completeness).

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
