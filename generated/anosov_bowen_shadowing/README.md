# `anosov_bowen_shadowing`

Anosov–Bowen shadowing lemma

- Problem ID: `anosov_bowen_shadowing`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Every compact hyperbolic invariant set K ⊆ ℝᵈ of a C¹ diffeomorphism T : ℝᵈ → ℝᵈ admits an open neighbourhood U ⊇ K such that every ε-pseudo-orbit of T inside U is δ-close to a true forward T-orbit (for ε sufficiently small relative to δ). Hyperbolicity is bundled as a `HyperbolicStructure': a pointwise stable/unstable splitting `ℝᵈ = Eˢ x ⊕ Eᵘ x' for each `x ∈ K' with the uniform exponential contraction/expansion estimates of Anosov's original definition (rate `λ ∈ (0,1)`, constant `C > 0`). The standard textbook definition additionally asks for the splitting to be continuous in `x'; this submission encodes only the pointwise content with uniform constants — the minimal data the shadowing proof depends on. The Euclidean ℝᵈ formulation is a faithful finite-dimensional local model, avoiding the smooth-manifold and tangent-bundle infrastructure mathlib does not yet package. §67 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: D.V. Anosov, 'Geodesic flows on closed Riemannian manifolds with negative curvature', Trudy Mat. Inst. Steklov. 90 (1967); R. Bowen, 'ω-limit sets for Axiom A diffeomorphisms', J. Differential Equations 18 (1975) 333–339. Listed as §67 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The classical proof uses (i) **cone fields**: a smooth field of stable and unstable cones around the splitting that is forward-invariant under `dT` (resp. backward-invariant under `dT⁻¹`); (ii) **graph transform**: the local stable/unstable manifolds at each point are constructed as fixed points of a contraction on the space of graphs over `Eˢ` (resp. `Eᵘ`) inside the cone field; (iii) **shadowing fixed point**: an ε-pseudo-orbit `(xₙ)` in a small neighbourhood of `K` is shadowed by a true orbit obtained as the fixed point of a contraction on bounded sequences `(yₙ)` with `yₙ` near `xₙ`, the contraction being a uniform consequence of the hyperbolic splitting. Mathlib has `fderiv`, `ContDiff`, `Submodule` complementarity (`IsCompl`), and `Function.iterate`, but no hyperbolic-dynamics infrastructure: no cone fields, no graph-transform machinery, no shadowing theorem, no Anosov / Axiom A diffeomorphism predicates.

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
