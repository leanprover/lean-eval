# `liouville_arnold`

Liouville–Arnold theorem on integrable systems

- Problem ID: `liouville_arnold`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §45 of Knill's 'Some Fundamental Theorems in Mathematics'. On a 2n-dimensional symplectic manifold with n smooth, pointwise linearly independent, pairwise Poisson-commuting first integrals F₁, …, F_n, every compact connected component of a joint level set is diffeomorphic to the n-torus T^n. Formalized on ℝ^{2n} with the standard symplectic form ω₀ = ∑ᵢ dpᵢ ∧ dqᵢ. Mathlib has EuclideanSpace, fderiv, AddCircle, Homeomorph but no Poisson brackets, no symplectic manifolds beyond Matrix.symplecticGroup, no first integrals, and no Liouville–Arnold theorem in any form (the Liouville files in Mathlib/Analysis/Complex/ are Liouville's theorem on bounded entire functions, a different result). The Challenge ships ~1 page of helper definitions (E, idxP, idxQ, poissonBracket, IsLiouvilleIntegrable, levelSet).
- Source: V. I. Arnold, *Mathematical Methods of Classical Mechanics* (2nd ed., 1989), Theorem 49.A.1 (the standard modern reference). The result is due to Liouville (1855) for the local existence of action-angle coordinates and Arnold (1963) for the compact-connected-component topology. Listed as §45 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Joint hamiltonian flows of F₁, …, F_n commute (by Poisson-commutativity) and are everywhere transverse to the level set (by linear independence of the gradients), so each compact connected component carries a transitive free action of ℝⁿ. The stabilizer is a discrete subgroup of full rank n (compactness), hence isomorphic to ℤⁿ, exhibiting M_c as ℝⁿ/ℤⁿ ≃ T^n.

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
