import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Finset.Prod
import Mathlib.Order.UpperLower.Basic
import EvalTools.Markers

/-!
# The q-TSPP theorem

Statement of the Kauers-Koutschan-Zeilberger q-TSPP theorem.
-/

open scoped BigOperators

namespace QTSPP

noncomputable section

/- A Cell is a 3-tuple of nonnegative integers -/
abbrev Cell := ℕ × ℕ × ℕ

/- Cells are partially ordered via the product order -/
theorem cell_le_iff (a b : Cell) :
    a ≤ b ↔
      a.1 ≤ b.1 ∧
      a.2.1 ≤ b.2.1 ∧
      a.2.2 ≤ b.2.2 := by
  rfl

/- A box of size n is the set {0,1,...,n-1}^3-/
def box (n : ℕ) : Finset Cell :=
  (Finset.range n).product
    ((Finset.range n).product (Finset.range n))

/- A finite set of Cells is totally symmetric if
   it is invariant under the natural action of S_3 -/
def IsTotallySymmetric (π : Finset Cell) : Prop :=
  ∀ i j k : ℕ, (i, j, k) ∈ π →
    (i, k, j) ∈ π ∧
    (j, i, k) ∈ π ∧
    (j, k, i) ∈ π ∧
    (k, i, j) ∈ π ∧
    (k, j, i) ∈ π

/- A totally symmetric plane partition (TSPP) is
   a finite set of Cells that is an order ideal
   (in the natural partial order on Cells) and is
   also totally symmetric. Mathlib's "IsLowerSet"
   already captures the notion of an order ideal.-/
def IsTSPP (π : Finset Cell) : Prop :=
  IsLowerSet (π : Set Cell) ∧ IsTotallySymmetric π

/- tspps is the set of all TSPPs inside a box of size n,
   including the empty TSPP -/
def tspps (n : ℕ) : Finset (Finset Cell) := by
  classical
  exact (box n).powerset.filter IsTSPP

/- sortedTriples n is the set of all Cells (i, j, k)
   in the box of size n such that i ≤ j ≤ k -/
def sortedTriples (n : ℕ) : Finset Cell :=
  (box n).filter (fun c => c.1 ≤ c.2.1 ∧ c.2.1 ≤ c.2.2)

/- The q-TSPP theorem enumerates TSPPs by
   the number of orbits; this is equivalent
   to the number of cells whose coordinates
   are in weakly increasing order -/
def orbitCount (π : Finset Cell) : ℕ :=
  (π.filter (fun c => c.1 ≤ c.2.1 ∧ c.2.1 ≤ c.2.2)).card

/- The coordinateSum of a Cell (i,j,k) is i+j+k -/
def coordinateSum (c : Cell) : ℕ :=
  c.1 + c.2.1 + c.2.2

local notation "q" => (Polynomial.X : Polynomial ℤ)

/- The left-hand side of the q-TSPP theorem is
   the generating polynomial for TSPPs by orbitCount -/
def generatingPolynomial (n : ℕ) : Polynomial ℤ :=
  ∑ π ∈ tspps n, q ^ (orbitCount π)

/- To avoid any worries about division by zero, we
   multiply by the denominator of the right-hand side.
   Our Cell coordinates start from 0, while the usual
   statement of the q-TSPP theorem starts from 1, so
   care is needed to get the exponent of q right. -/
@[eval_problem]
theorem q_tspp (n : ℕ) :
    generatingPolynomial n *
      (∏ c ∈ sortedTriples n,
        (1 - q ^ (coordinateSum c + 1))) =
    ∏ c ∈ sortedTriples n,
      (1 - q ^ (coordinateSum c + 2)) := by
  sorry

end

end QTSPP
