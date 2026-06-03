# `fary_milnor`

Fáry–Milnor theorem (knot total curvature ≤ 4π implies unknotted)

- Problem ID: `fary_milnor`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: A smooth knot in ℝ³ with total curvature at most 4π is unknotted. A knot is a smooth, regular, 2π-periodic, simple-on-`[0, 2π)` curve `r : ℝ → ℝ³`. Curvature is the standard parametrized expression `‖r'(t) × r''(t)‖ / ‖r'(t)‖³`; total curvature is the arc-length integral. Unknottedness is encoded as a smooth isotopy through smooth knots from r to the standard unit circle. Mathlib has the analytic primitives (`deriv`, interval integrals, `ContDiff`, `crossProduct`, Euclidean norm) but no knot-total-curvature / unknottedness API. §161 of Knill's *Some Fundamental Theorems in Mathematics*.
- Source: I. Fáry, 'Sur la courbure totale d'une courbe gauche faisant un nœud', Bull. Soc. Math. France 77 (1949) 128–138; J. Milnor, 'On the total curvature of knots', Ann. of Math. (2) 52 (1950) 248–257. §161 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: The classical proof goes via the **crookedness** invariant `μ(r)` of a knot: for a generic unit vector `u ∈ S²`, let `M(u)` be the number of local maxima of the height function `t ↦ ⟨r(t), u⟩` on one period, and set `μ(r) := inf M(u)` over generic `u`. (1) Every smooth knot has `M(u) ≥ 1`. A nontrivial knot has `μ(r) ≥ 2`, by the *bridge lemma*: a curve with `μ(r) = 1` lies in two half-spaces meeting along a common boundary plane and bounds an embedded disk by interpolation, hence is unknotted (this is the content Knill calls Fáry/Milnor's crookedness step). (2) An integral-geometric Crofton-style identity, with the normalised area measure `dσ` on `S²` chosen so `∫_{S²} 1 dσ = 1`, gives `∫_{S²} M(u) dσ(u) = totalCurvature(r) / (2π)`. (3) Combining (1)–(2): for a nontrivial knot, `totalCurvature(r) / (2π) = ∫ M ≥ μ(r) ≥ 2`, hence `totalCurvature(r) ≥ 4π`; the contrapositive is the Fáry–Milnor theorem. Mathlib has interval integrals, deriv, `ContDiff`, and `crossProduct`, but no knot framework, no crookedness invariant, no Crofton-style integral-geometric identity, and no unknottedness criterion.

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
