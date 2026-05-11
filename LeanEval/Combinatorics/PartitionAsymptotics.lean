import Mathlib.Analysis.Asymptotics.Defs
import Mathlib.Combinatorics.Enumerative.Partition.Basic
import Mathlib.Analysis.Complex.Exponential
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-! # Asymptotic expression for the number of integer partitions

Hardy and Ramanujan's asymptotic expression for the number of integer partitions.

G. H. Hardy, S. Ramanujan. *Asymptotic formulae in combinatory analysis*, 1918.
-/

open Asymptotics Filter Fintype

/-- Hardy and Ramanujan's asymptotic formula. -/
@[eval_problem]
theorem isEquivalent_card_partition :
  (fun (n : ℕ) => (card n.Partition : ℝ)) ~[atTop]
  (fun n => Real.exp (Real.pi * Real.sqrt (2 * n / 3)) / (4 * n * Real.sqrt 3)) := sorry
