# `golod_shafarevich_inequality`

The Golod–Shafarevich inequality

- Problem ID: `golod_shafarevich_inequality`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For every prime p and every nontrivial finite p-group Q, d(Q)² < 4 r(Q), where d(Q) is the generator rank (minimal size of a generating set) and r(Q) = dim_{𝔽_p} H²(Q; 𝔽_p) is the relation rank. The trusted helpers generatorRank and relationRank (non-holes) fix the meaning of d and r, viewing a finite p-group as a discrete topological group so that topological generation and continuous cohomology agree with their abstract counterparts. This is one of the two external inputs taken as a hypothesis in Logical Intelligence's formalization of the disproof of Erdős's unit-distance conjecture (Hyp_GolodShafarevichInequality). The statement was reviewed for faithfulness against NSW Theorem 3.9.7 and Serre.
- Source: NSW (J. Neukirch, A. Schmidt, K. Wingberg, *Cohomology of Number Fields*, 2nd ed., Grundlehren 323, Springer 2008), Theorem 3.9.7; J.-P. Serre, *Galois Cohomology*, Chapter I, Appendix 2, Theorem 1. Lean hypothesis: https://github.com/logical-intelligence/erdos-unit-distance (Hyp_GolodShafarevichInequality).
- Informal solution: The Golod–Shafarevich theorem: a finite p-group with generator rank d and relation rank r, where r is identified with dim_{𝔽_p} H²(Q; 𝔽_p) (equivalently the number of relations in a minimal pro-p presentation), satisfies r > d²/4. Proof via the graded 𝔽_p-algebra of the group: form the completed group algebra 𝔽_p⟦Q⟧, filter by powers of the augmentation ideal, and study the associated graded algebra A = ⊕ 𝔞ⁿ/𝔞ⁿ⁺¹. With d generators and r relations its Hilbert series H_A(t) is bounded below termwise by (1 - dt + rt²)⁻¹; if d² ≥ 4r the quadratic 1 - dt + rt² has a positive real root, forcing the (nonnegative) coefficients to fail to terminate, contradicting finiteness of Q. Hence d² < 4r.

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
