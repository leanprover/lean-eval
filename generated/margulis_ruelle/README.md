# `margulis_ruelle`

Margulis–Ruelle inequality

- Problem ID: `margulis_ruelle`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Margulis (1968) / Ruelle (1978): for a C²-diffeomorphism T of a compact surface and a T-invariant ergodic probability measure μ, the Kolmogorov–Sinai entropy is bounded by the sum of the positive parts of the Lyapunov exponents, h_μ(T) ≤ λ₁⁺ + λ₂⁺. Shares the §103 trusted helpers (kolmogorovSinaiEntropy, lyapunov* via totalized sSup/limsup; genuine in the compact-C² regime). Not in Mathlib (no KS entropy, no Lyapunov exponents). Candidate from §103 of the Knill survey.
- Source: D. Ruelle, *An inequality for the entropy of differentiable maps*, Bol. Soc. Brasil. Mat. 9 (1978); G. A. Margulis (1968, unpublished). Knill, *Some fundamental theorems in mathematics*, §103.
- Informal solution: Ruelle's inequality. Cover the manifold by a fine partition and estimate the number of partition atoms an orbit can be distinguished into after n steps: the differential DT^n expands volumes by at most ∏ⱼ exp(n·λⱼ⁺) up to subexponential factors, so the n-step refinement ∨_{k<n} T^{-k}P has at most exp(n·∑λⱼ⁺ + o(n)) essential atoms. Hence (1/n)H_μ(∨ T^{-k}P) ≤ ∑λⱼ⁺ + o(1), and taking the partition-supremum gives h_μ ≤ ∑λⱼ⁺. Uses Oseledec exponents and the volume-growth bound; not in Mathlib.

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
