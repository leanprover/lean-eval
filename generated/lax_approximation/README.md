# `lax_approximation`

Lax's approximation theorem for toral homeomorphisms

- Problem ID: `lax_approximation`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Peter Lax (1971): every volume-preserving homeomorphism of the d-torus (d ≥ 1) is approximated arbitrarily well, in the L∞-metric δ(T,S) = ess sup d(Tx,Sx), by cyclic cube exchange transformations (a single full nᵈ-cycle rigidly permuting the 1/n-grid cubes). Trusted helpers (Torus, VolumePreservingEquiv, deltaDist, ToralDynamicalSystem, cube, cubeShift, IsCyclicCubeExchange) are non-holes. 'Cyclic' = σ.IsCycle ∧ σ.support = univ; 0 < d required. Mathlib has the torus, measure-preserving maps, and Hall's marriage theorem but not Lax's theorem or cube exchanges. Candidate from §110 of the Knill survey.
- Source: P. D. Lax, *Approximation of measure preserving transformations*, Comm. Pure Appl. Math. 24 (1971). Knill, *Some fundamental theorems in mathematics*, §110.
- Informal solution: Lax's grid argument. Fix a fine mesh n with 1/n < ε-scale. Partition 𝕋ᵈ into nᵈ cubes; since T is volume-preserving, the images T(cube k) and the cubes match up in measure, so by Hall's marriage theorem there is a bijection σ of cube-indices with T(cube k) ∩ cube(σ k) of positive measure (each target within ε of the source), giving a cube exchange S₀ with δ(T,S₀) small. Upgrade σ to a single full cycle: any permutation is a product of cycles, and one can perturb/relabel within the ε-tolerance (concatenating the cycles through shared boundary cubes) to make it one nᵈ-cycle without increasing δ beyond ε. Requires the measure-matching (Hall) and the cyclic upgrade, neither packaged in Mathlib.

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
