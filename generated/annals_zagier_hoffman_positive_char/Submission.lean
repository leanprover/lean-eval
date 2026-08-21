/-
Copyright (c) 2026 Katerina Hristova. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Katerina Hristova
-/

import Mathlib.NumberTheory.FunctionField
import Mathlib.RingTheory.SimpleRing.Principal
import Submission.Helpers
import ChallengeDeps
/-!
# Main Statements from On Zagier-Hoffman's conjectures in positive characteristic

We formalise the statements of the main results from T. N. Dac,
`On Zagier-Hoffman's conjectures in positive characteristic`, Annals of Math, 194 (1) 2021.

## Implementation Details

Throughout the definitions and statements, we reindex the `i`'s so that they run from `0`
to `r - 1` rather than from `1` to `r`.
-/


namespace Submission

open _root_.ZagierHoffmanPositiveChar
set_option autoImplicit false

namespace ZagierHoffmanPositiveChar

open NNReal Polynomial RatFunc

variable (F : Type*) [Field F] [Finite F] [DecidableEq (RatFunc F)]





















/--
Statement of Theorem A (Brown's theorem in positive characteristic):

Let `w ∈ ℕ`, where `ℕ := {1,2,...}`. Then every MZV of weight `w` can be written as a `K`-linear
combination of MZV's in the set `𝒯_w`. In particular, `dim 𝒵_w ≤ d(w)`.
Note that `K` in the paper is `RatFunc F`.
-/
theorem theorem_A (w : ℕ+) :
    𝒵 F w = Submodule.span (RatFunc F) (𝒯 F w) ∧
    Module.rank (RatFunc F) (𝒵 F w) ≤ d F w := by
  sorry

/--
Statement of Theorem B:

Let `w ∈ ℕ`, where `ℕ := {1,2,...}`. MZVs of weight `w` in `𝒯0 w` are all linearly independent over
`K`. In particular, `dim 𝒵 w ≥ |𝒯0 w|`. Note that `K` in the paper is `RatFunc F`.
-/
theorem theorem_B (w : ℕ+) :
    LinearIndependent (RatFunc F) (Subtype.val : 𝒯0 F w → CompletionAtInfty F) ∧
    Module.rank (RatFunc F) (𝒵 F w) ≥ Set.ncard (𝒯0 F w) := by
  sorry

/--
Statement of Theorem D:

Let `w ∈ ℕ+` with `w ≤ 2q − 2`. Then `𝒯 w` is a `K`-basis for `𝒵 w`. In particular,
`dim_K (𝒵 w) = d(w)`. Note that `K` in the paper is `RatFunc F`.

Note: Theorem A establishes that `𝒯 w` spans `𝒵 w`. So to prove `𝒯 w` is a `K`-basis for `𝒵 w`, we
only need to show that `𝒯 w` are linearly independent in `𝒵 w`.
-/
theorem theorem_D (w : ℕ+) (hw : w ≤ 2 * Nat.card F - 2) :
    LinearIndependent (RatFunc F) (Subtype.val : 𝒯 F w → CompletionAtInfty F) ∧
    Module.rank (RatFunc F) (𝒵 F w) = d F w := by
  sorry

end ZagierHoffmanPositiveChar

end Submission
