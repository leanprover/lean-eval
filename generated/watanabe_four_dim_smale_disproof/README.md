# `watanabe_four_dim_smale_disproof`

Watanabe's disproof of the 4-dimensional Smale conjecture

- Problem ID: `watanabe_four_dim_smale_disproof`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Resolves [Kir97, Problems 4.34 and 4.126] negatively: the 4-dimensional generalized Smale conjecture (O(5) ↪ Diff(S⁴) is a homotopy equivalence, equivalently Diff(D⁴ rel ∂) is contractible) is false. Watanabe showed πₖ(Diff(D⁴ rel ∂)) ⊗ ℚ ≠ 0 for many k, including k = 1, via configuration-space integrals. We state this as the negation of the exact four-dimensional analogue of the (true) S³ Smale conjecture in SmaleConjecture.lean — relative parameterized form, because Mathlib has no C^∞ topology on diffeomorphism groups yet.
- Source: T. Watanabe, *Some exotic nontrivial elements of the rational homotopy groups of Diff(S⁴)*, arXiv:1812.02448 (2018). Pairs with the positive S³ statement of Hatcher (Ann. of Math. 117, 1983) in SmaleConjecture.lean.
- Informal solution: No formalization is feasible today: this needs the C^∞ topology on diffeomorphism groups, configuration-space integrals / Kontsevich classes, and the graph-cohomology machinery Watanabe uses. The statement is the negation of the parameterized homotopy-equivalence claim, which Watanabe's nontriviality result refutes.

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
