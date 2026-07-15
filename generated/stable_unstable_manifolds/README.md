# `stable_unstable_manifolds`

Local stable/unstable sets at a hyperbolic fixed point (set-level Hadamard–Perron)

- Problem ID: `stable_unstable_manifolds`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a C¹ map f : ℝⁿ → ℝⁿ with an invertible hyperbolic fixed point x₀ (no eigenvalue of dfₓ₀ on the unit circle, plus invertibility to exclude the degenerate zero-eigenvalue case), some open neighbourhood U ∋ x₀ carries the genuinely local stable set Wˢ = {x | ∀ k, f^[k] x ∈ U ∧ f^[k] x → x₀} and the local unstable set Wᵘ = {x | ∃ backward orbit y with y 0 = x, y k ∈ U for all k, and y → x₀}, with Wˢ ∩ Wᵘ = {x₀}. The 'orbit stays in U' clause is essential: without it, homoclinic points (forward and backward limit x₀ with excursions outside U) would falsify Wˢ ∩ Wᵘ = {x₀} in systems with homoclinic dynamics. This submission ships the set-level topological shadow of Hadamard–Perron; the full theorem additionally asserts that Wˢ, Wᵘ are immersed C¹ submanifolds tangent to the stable/unstable eigenspaces (same proof difficulty), which this Lean statement does not encode. §104 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: J. Hadamard, 'Sur l'itération et les solutions asymptotiques des équations différentielles', Bull. Soc. Math. France 29 (1901); O. Perron, 'Über Stabilität und asymptotisches Verhalten der Integrale von Differentialgleichungssystemen', Math. Z. 29 (1929) 129–160. Listed as §104 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The Hadamard graph-transform proof: write `f` near `x₀` as `f(x₀ + v) = x₀ + A v + g(v)` with `A = df(x₀)`, `g(v) = o(‖v‖)`. The hyperbolic splitting `ℝⁿ = Eˢ ⊕ Eᵘ` (stable / unstable eigenspaces of `A`) lets one parametrise the candidate `Wˢ` as the graph of a Lipschitz function `σ : Eˢ → Eᵘ` near 0, with `σ(0) = 0`. The graph transform `G(σ) := graph of (the new function whose graph is f(graph σ) ∩ small box)` is a contraction on the Banach space of Lipschitz functions `Eˢ → Eᵘ` of small Lipschitz constant, because the stable direction contracts under `A` and the unstable direction expands (Banach fixed point). The unique fixed-point graph is the local stable manifold; the same argument with `f⁻¹` gives `Wᵘ`. Hyperbolicity forces `Wˢ ∩ Wᵘ = {x₀}`: a point on both has its forward iterates bounded (lying on the bounded `Wˢ`) and its backward iterates bounded too, but the hyperbolic splitting forces such doubly-bounded orbits to be {x₀}. Mathlib has `fderiv`, `ContDiff`, `Filter.Tendsto`, `Polynomial.roots`, and `LinearMap.charpoly`, but no Hadamard–Perron theorem, no graph-transform machinery, no stable/unstable manifold framework, and no `IsHyperbolicLinear` predicate.

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
