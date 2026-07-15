# `euler_lagrange_equation`

Euler–Lagrange equation

- Problem ID: `euler_lagrange_equation`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: §44 of Oliver Knill's 'Some Fundamental Theorems in Mathematics'. The Euler–Lagrange equation: a sufficiently regular stationary path x of the action I(y) = ∫_a^b L(t, y(t), y'(t)) dt satisfies ∂L/∂x = (d/dt)(∂L/∂x') pointwise on the open interval (a, b). Stationarity is expressed as the first variation of the action vanishing against every smooth compactly supported perturbation inside (a, b). It is the central necessary condition of the calculus of variations. mathlib has related ingredients such as the fundamental lemma of the calculus of variations, but no bundled action-functional extremum notion and no Euler–Lagrange theorem.
- Source: L. Euler (1744) and J.-L. Lagrange (1755). Listed as §44 in O. Knill, Some Fundamental Theorems in Mathematics (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Let h be a smooth variation with compact support in (a, b). Differentiating I(x + ε h) under the integral at ε = 0 gives the first variation ∫_a^b (∂L/∂x · h + ∂L/∂x' · h') dt, which vanishes for all such h since x is a variational extremum. Integrate the second term by parts; the boundary terms vanish because h is compactly supported in (a, b), leaving ∫_a^b (∂L/∂x − d/dt(∂L/∂x')) h dt = 0 for all h. By the fundamental lemma of the calculus of variations the continuous factor ∂L/∂x − d/dt(∂L/∂x') is identically zero on (a, b), which is the Euler–Lagrange equation. C² regularity of L and x makes ∂L/∂x' differentiable in t so the integration by parts and the d/dt term are justified.

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
