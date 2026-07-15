# `hopf_rinow`

Hopf–Rinow theorem

- Problem ID: `hopf_rinow`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: For a connected, finite-dimensional, smooth Riemannian manifold M that is also locally compact, metric completeness and geodesic completeness are equivalent. §93 of Knill's 'Some Fundamental Theorems in Mathematics'. The file ships IsGeodesic (a path with locally linear edist — a metric formulation of affinely parametrised local minimising geodesics, avoiding any Levi-Civita / connection infrastructure) and IsGeodesicallyComplete (every geodesic on a bounded open interval extends to all of ℝ).
- Source: H. Hopf and W. Rinow, *Ueber den Begriff der vollständigen differentialgeometrischen Fläche*, Comment. Math. Helv. 3 (1931), 209-225. Listed as §93 in O. Knill, *Some Fundamental Theorems in Mathematics* (https://people.math.harvard.edu/~knill/graphgeometry/papers/fundamental.pdf).
- Informal solution: Standard Hopf–Rinow proof. Metric ⇒ geodesic completeness: a constant-speed geodesic γ : (a, b) → M is uniformly Cauchy as t → b⁻ because edist (γ s) (γ t) = c · |s − t|; the limit exists by metric completeness, and the geodesic ODE extends past the limit point using local existence of geodesics (Picard–Lindelöf on the tangent bundle). Geodesic ⇒ metric completeness: the central Hopf–Rinow lemma shows that under the smooth-Riemannian-and-locally-compact hypotheses, closed bounded subsets of M are compact (Heine–Borel). A Cauchy sequence is bounded, hence contained in a compact set, hence convergent.

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
