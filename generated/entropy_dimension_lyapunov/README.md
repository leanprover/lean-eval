# `entropy_dimension_lyapunov`

Lai-Sang Young entropy–dimension–Lyapunov theorem

- Problem ID: `entropy_dimension_lyapunov`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Lai-Sang Young (1982): for a C²-diffeomorphism T of a compact surface (modelled on EuclideanSpace ℝ (Fin 2) with a compact invariant K) and a T-invariant ergodic probability measure μ, h_μ(T) = dim(μ)·λ(T,μ)/2, where λ(T,μ) is the harmonic mean of (λ₁, −λ₂). Shares trusted (non-hole) helpers with the rest of §103: dimMeasure, kolmogorovSinaiEntropy (via sSup), entropyW/lyapunov* (via Filter.limsup), harmonicMeanLyapunov. These helpers are total functions (sSup/limsup are junk outside their intended bounded regime); in the compact-C² setting entropy and exponents are finite and the (DT^n)⁻¹ is genuine because T has a C² two-sided inverse. Mathlib has dimH, Ergodic, MeasurePreserving, Real.negMulLog, fderiv, but no Kolmogorov–Sinai entropy, no Lyapunov exponents/Oseledec, and none of these theorems. Candidate from §103 of the Knill survey.
- Source: L.-S. Young, *Dimension, entropy and Lyapunov exponents*, Ergodic Theory Dynam. Systems 2 (1982), 109–124. Knill, *Some fundamental theorems in mathematics*, §103.
- Informal solution: Young's argument relates the Kolmogorov–Sinai entropy, the Hausdorff dimension of μ, and the Lyapunov exponents for a surface diffeomorphism. Build a measurable partition into small dynamical rectangles aligned with the stable/unstable directions (Oseledec splitting); the entropy is computed along unstable manifolds (Shannon–McMillan–Breiman) while the pointwise dimension dim(μ) is governed by the contraction/expansion rates λ₁, −λ₂ via a Borel–Cantelli/covering argument. Equating the two expressions for the local scaling of μ-mass on dynamical balls gives h_μ = dim(μ)·(2λ₁(−λ₂)/(λ₁−λ₂))/2. Requires Oseledec MET, absolute continuity of the unstable foliation, and the entropy-via-increasing-partitions machinery, none in Mathlib.

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
