# `shannon_capacity_pentagon`

Shannon capacity of the pentagon

- Problem ID: `shannon_capacity_pentagon`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Lovász's computation: the Shannon capacity of the five-cycle C₅ is √5. The helpers IsIndependent, independenceNumber, strongPower, and HasShannonCapacity encode the capacity as the limit of (α(Gᵏ))^{1/k}, modelling length-k words as Fin k → V. Mathlib has finite simple graphs and cycle graphs but no Shannon capacity, strong graph powers, Lovász theta number, or the semidefinite-programming bound. Category-(b) candidate.
- Source: Knill, *Some fundamental theorems in mathematics*, §238.
- Informal solution: Lovász's theta-function argument. Lower bound: the strong square C₅⊠C₅ has an independent set of size 5 (e.g. {(0,0),(1,2),(2,4),(3,1),(4,3)}), so α(C₅⊠C₅) ≥ 5, giving capacity ≥ √5. Upper bound: the Lovász number ϑ is multiplicative under the strong product and satisfies α(G) ≤ ϑ(G), so the capacity Θ(G) = lim (α(Gᵏ))^{1/k} ≤ ϑ(G); computing ϑ(C₅) = √5 (via the umbrella/orthonormal-representation construction, or the eigenvalue bound for vertex-transitive graphs) gives capacity ≤ √5. The two bounds coincide at √5.

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
