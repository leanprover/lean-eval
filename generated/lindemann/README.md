# `lindemann`

Lindemann's theorem (e and π transcendental)

- Problem ID: `lindemann`
- Test Problem: no
- Submitter: Kim Morrison
- Notes: Both e = exp 1 and π are transcendental over ℤ (Lindemann 1882). Mathlib has Transcendental and the analytic scaffolding of the Lindemann–Weierstrass proof (Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart) but no transcendence statement for e or π. No new definitions needed. Candidate from §55 of the Knill survey. (The companion irrationality of π is already in Mathlib as irrational_pi.)
- Source: F. Lindemann, *Über die Zahl π*, Math. Ann. 20 (1882). Knill, *Some fundamental theorems in mathematics*, §55.
- Informal solution: Transcendence of e and π via the Hermite–Lindemann method, the x=1 / x=iπ special cases of Lindemann–Weierstrass. For e: assume a polynomial relation ∑ aₖ eᵏ = 0 and derive a contradiction using Hermite's integral ∫ e^{-t} f(t) dt with f a high-power polynomial, getting a nonzero integer of absolute value < 1. For π: if π were algebraic so would be iπ; apply the symmetric-function/Galois argument to ∏(1 + e^{αⱼ}) where αⱼ are the conjugates of iπ, using e^{iπ} = −1, again reducing to a nonzero integer that is too small. Mathlib's AnalyticalPart supplies the integral estimates; the symmetric-function finish is the missing piece.

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
