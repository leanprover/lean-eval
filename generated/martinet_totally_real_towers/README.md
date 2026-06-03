# `martinet_totally_real_towers`

Martinet's asymptotically-good totally real towers

- Problem ID: `martinet_totally_real_towers`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: There is an absolute C > 0 such that for infinitely many degrees d there is a totally real number field K of degree d over ℚ with |Δ_K| ≤ C^d, i.e. a family of totally real fields of growing degree with bounded root discriminant rd_K = |Δ_K|^{1/d} ≤ C. This is the sole classical input taken as an axiom in the sum_product formalization of Bloom–Sawin–Schildkraut–Zhelezov's refutation of the sum-product conjecture over ℝ (SumProduct.exists_totallyReal_discr_le). Removing it would require formalizing Martinet's tower construction (asymptotically-good totally real towers from class field theory / Golod–Shafarevich), not currently in Mathlib. The statement was reviewed for faithfulness against arXiv:2605.28781 Theorem 3.2.
- Source: Theorem 3.2 of T. F. Bloom, W. Sawin, C. Schildkraut, D. Zhelezov, *The sum-product conjecture is false for real numbers*, arXiv:2605.28781. Lean axiom: https://github.com/mathlib-initiative/sum_product (SumProduct.exists_totallyReal_discr_le). Underlying result: J. Martinet, *Tours de corps de classes et estimations de discriminants*, Invent. Math. 44 (1978), 65–73.
- Informal solution: Build asymptotically-good totally real towers via class field theory. Following Hajir–Maire / Martinet: start from a totally real base field admitting an infinite unramified pro-p tower (kept infinite by Golod–Shafarevich, r(G) > d(G)²/4 forcing the maximal unramified pro-p Galois group to be infinite), so the tower fields have constant root discriminant; pick a cofinal sequence of degrees d and take K to be the corresponding tower field, whose discriminant satisfies |Δ_K| = rd^d ≤ C^d for the absolute constant C = rd.

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
