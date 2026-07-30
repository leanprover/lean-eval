import Mathlib
import EvalTools.Markers

namespace LeanEval.Combinatorics.HoneycombConnectiveConstant

/-!
# The connective constant of the honeycomb lattice

Duminil-Copin and Smirnov proved Nienhuis's prediction that the connective
constant of the honeycomb (hexagonal) lattice is `sqrt (2 + sqrt 2)`.

The lattice is represented in bipartite integer coordinates. A vertex
`(x, y, false)` is adjacent to `(x, y, true)`, `(x - 1, y, true)`, and
`(x, y - 1, true)`; the reverse moves apply on the other side. Thus a
finite direction word determines a walk, and injectivity of its sequence
of visited vertices is exactly the self-avoiding condition.
-/

open Filter Topology

/-- Bipartite integer coordinates for the vertices of the honeycomb lattice. -/
structure HoneycombVertex where
  x : ℤ
  y : ℤ
  side : Bool
deriving DecidableEq

/-- Take one of the three incident edges at a honeycomb-lattice vertex. -/
def step (v : HoneycombVertex) (direction : Fin 3) : HoneycombVertex :=
  if v.side then
    match direction.1 with
    | 0 => ⟨v.x, v.y, false⟩
    | 1 => ⟨v.x + 1, v.y, false⟩
    | _ => ⟨v.x, v.y + 1, false⟩
  else
    match direction.1 with
    | 0 => ⟨v.x, v.y, true⟩
    | 1 => ⟨v.x - 1, v.y, true⟩
    | _ => ⟨v.x, v.y - 1, true⟩

/-- Traversing the same locally labelled edge twice returns to the starting
vertex. In particular, the coordinate model defines an undirected graph. -/
@[simp]
theorem step_step (v : HoneycombVertex) (direction : Fin 3) :
    step (step v direction) direction = v := by
  rcases v with ⟨x, y, side⟩
  fin_cases direction
  all_goals cases side
  all_goals simp [step]

/-- The three direction labels at a vertex select three distinct neighbors. -/
theorem step_injective (v : HoneycombVertex) : Function.Injective (step v) := by
  intro direction₁ direction₂ h
  rcases v with ⟨x, y, side⟩
  cases side
  all_goals fin_cases direction₁
  all_goals fin_cases direction₂
  all_goals simp [step] at h ⊢
  all_goals omega

/-- A fixed origin in the vertex-transitive honeycomb lattice. -/
def origin : HoneycombVertex := ⟨0, 0, false⟩

/-- The endpoint reached by following a finite word of directions from the origin. -/
def endpoint (directions : List (Fin 3)) : HoneycombVertex :=
  directions.foldl step origin

/-- The vertex visited after the first `i` steps of a direction word. -/
def vertexAt {n : ℕ} (directions : Fin n → Fin 3) (i : Fin (n + 1)) :
    HoneycombVertex :=
  endpoint ((List.ofFn directions).take i.1)

/-- The finite set of vertices visited by a direction word, including the origin. -/
def visitedVertices {n : ℕ} (directions : Fin n → Fin 3) : Finset HoneycombVertex :=
  Finset.univ.image (vertexAt directions)

/-- A direction word is self-avoiding when its `n + 1` visited vertices are distinct. -/
def IsSelfAvoiding {n : ℕ} (directions : Fin n → Fin 3) : Prop :=
  (visitedVertices directions).card = n + 1

instance {n : ℕ} (directions : Fin n → Fin 3) : Decidable (IsSelfAvoiding directions) := by
  unfold IsSelfAvoiding
  infer_instance

/-- The number of `n`-step self-avoiding walks on the honeycomb lattice
starting at the origin. -/
def walkCount (n : ℕ) : ℕ :=
  (Finset.univ.filter fun directions : Fin n → Fin 3 =>
    IsSelfAvoiding directions).card

/-- A small computable check of the lattice encoding: there are twelve
three-step self-avoiding walks from a fixed honeycomb vertex. -/
theorem walkCount_three : walkCount 3 = 12 := by
  decide

set_option maxRecDepth 10000 in
/-- At six steps the first hexagonal cycle appears; the standard count is `90`. -/
theorem walkCount_six : walkCount 6 = 90 := by
  decide

/-- **Duminil-Copin-Smirnov honeycomb connective-constant theorem.** The
exponential growth rate of the number of self-avoiding walks is
`sqrt (2 + sqrt 2)`. -/
@[eval_problem]
theorem honeycomb_connective_constant :
    Tendsto
      (fun n ↦ (walkCount n : ℝ) ^ (1 / n : ℝ))
      atTop
      (nhds (Real.sqrt (2 + Real.sqrt 2))) := by
  sorry

end LeanEval.Combinatorics.HoneycombConnectiveConstant
