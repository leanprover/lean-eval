# `nash_equilibrium_exists`

Nash equilibrium existence theorem

- Problem ID: `nash_equilibrium_exists`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §33 of Oliver Knill's 'Some Fundamental Theorems in Mathematics' (the section's boxed main theorem). Every finite n-player game in mixed strategies admits at least one Nash equilibrium. Mathlib has stdSimplex ℝ S (the natural model of a mixed strategy) and finite-sum/product machinery but no game theory at all — no Mathlib/GameTheory/ module, and grep for nash/mixed.strategy/best.response returns nothing relevant. No formalization of Nash equilibrium existence was found in any major proof assistant.
- Source: J. F. Nash, Equilibrium points in n-person games, Proc. Nat. Acad. Sci. U.S.A. 36 (1950), 48-49; Non-cooperative games, Ann. of Math. 54 (1951), 286-295. Listed as §33 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Nash's 1950 proof (via Brouwer): define the best-response function r : Δ → Δ on the product of mixed-strategy simplices Δ = ∏ᵢ Δ(Sᵢ), where r(σ)ᵢ(sᵢ) = (σᵢ(sᵢ) + max(0, gain_i(σ, sᵢ))) / (normalization), and gain_i(σ, sᵢ) is the improvement player i would get by playing the pure strategy sᵢ against σ_{-i}. r is continuous and Δ is nonempty compact convex; Brouwer gives a fixed point σ*, and a short calculation shows σ* must be a Nash equilibrium (the only fixed points of r are exactly the equilibria). Nash's 1951 proof uses Kakutani directly: the best-response correspondence (set-valued, not single-valued) is upper-hemicontinuous with nonempty convex values; apply Kakutani to get a fixed point.

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
