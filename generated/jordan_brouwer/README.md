# `jordan_brouwer`

Jordan–Brouwer separation theorem

- Problem ID: `jordan_brouwer`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §48 of Knill's 'Some Fundamental Theorems in Mathematics'. The high-dimensional generalization of the Jordan curve theorem: for d ≥ 2, the complement in ℝᵈ of a topological (d-1)-sphere has exactly two connected components. The hypothesis 2 ≤ d is essential: in dimension d = 1 the (d-1)-sphere is the two-point set {-1, 1}, whose complement in ℝ has three connected components. Mathlib has Metric.sphere, EuclideanSpace, ConnectedComponents, Nat.card, but no Jordan–Brouwer separation theorem, no Alexander duality, no invariance of domain in a form that would discharge it. Stateable with zero new definitions.
- Source: L. E. J. Brouwer, *Beweis des Jordanschen Satzes für den n-dimensionalen Raum*, Math. Annalen 71 (1912) (first proof). Listed as §48 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf). No formalization found in any major prover.
- Informal solution: Modern proofs use singular homology via Alexander duality: H̃_0(ℝᵈ ∖ Σ) ≅ H̃^{d-1}(Σ), and an embedded (d-1)-sphere Σ has H̃^{d-1}(Σ) ≅ ℤ, giving exactly two components. Brouwer's original proof used direct simplicial-approximation arguments without modern homology.

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
