# `monge_kantorovich`

Monge–Kantorovich existence theorem

- Problem ID: `monge_kantorovich`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §73 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. The Monge–Kantorovich existence theorem states that for Polish probability spaces (X, P) and (Y, Q) and a continuous cost c : X × Y → [0, ∞], the functional π ↦ ∫ c dπ attains its minimum over all couplings of P and Q (the probability measures on X × Y with marginals P and Q). This is the basic existence result for optimal transport plans. Mathlib has the surrounding measure-theoretic and topological infrastructure — marginals, probability measures, weak convergence, Prokhorov-type compactness — but no dedicated coupling or Kantorovich-cost API and no theorem asserting existence of an optimal coupling.
- Source: L. V. Kantorovich (1942), after G. Monge (1781). Listed as §73 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The set of couplings Π(P, Q) is nonempty (the product measure P ⊗ Q is a coupling), and it is tight and weakly closed: each marginal P, Q is tight by Prokhorov on a Polish space, tightness of the marginals gives tightness of the couplings, and the marginal constraints π.fst = P, π.snd = Q are preserved under weak limits, so by Prokhorov's theorem Π(P, Q) is weakly compact. The Kantorovich functional π ↦ ∫ c dπ is weakly lower semicontinuous because c is continuous and nonnegative (write c as an increasing limit of bounded continuous functions and use the portmanteau characterisation). A lower semicontinuous function on a (nonempty) compact set attains its infimum, giving an optimal coupling.

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
