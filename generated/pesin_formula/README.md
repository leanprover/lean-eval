# `pesin_formula`

Pesin entropy formula (symplectic surface case)

- Problem ID: `pesin_formula`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Pesin (1977), symplectic surface specialisation of Lai-Sang Young: for an ergodic surface diffeomorphism with dim(μ) = 2 and symmetric averaged exponents (∫λ₁ = −∫λ₂), h_μ(T) = ∫λ₁. The symplectic/volume-preserving case is encoded here via dimMeasure μ = 2 and the exponent-symmetry hypothesis (a consequence-form, not a full symplectic-derivative hypothesis package). Shares the §103 trusted helpers (totalized sSup/limsup; genuine in the compact-C² regime). Not in Mathlib (no KS entropy, no Lyapunov exponents, no Pesin formula). Candidate from §103 of the Knill survey.
- Source: Ya. B. Pesin, *Characteristic Lyapunov exponents and smooth ergodic theory*, Russian Math. Surveys 32 (1977). Knill, *Some fundamental theorems in mathematics*, §103.
- Informal solution: Pesin's formula h_μ = ∑ λⱼ⁺ for smooth invariant measures absolutely continuous w.r.t. volume. In the surface case with dim(μ) = 2 (full dimension forces μ ≪ volume) and λ₁ = −λ₂, the entropy equals the single positive exponent λ₁. Proof: the Margulis–Ruelle inequality gives h_μ ≤ λ₁⁺; the reverse inequality (the substantive half) uses absolute continuity of the unstable foliation / the SRB property to show entropy is at least the unstable expansion rate. Here it is obtained as the dim(μ)=2 specialisation of the Lai-Sang Young formula. Requires Pesin theory absent from Mathlib.

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
