import Mathlib

namespace LeanEval.Analysis.IsingPhaseTransition

/-!
# Onsager's 2D Ising phase transition

`ising_2d_phase_transition` (Onsager 1944): the thermodynamic-limit free energy
of the zero-field ferromagnetic square-lattice Ising model exists for every
inverse temperature and is non-analytic at a positive critical point. Trusted
helpers (`isingEnergy`, `isingPartitionFunction`, `finiteIsingFreeEnergy`, …)
are non-holes. Mathlib has no statistical-mechanics / Ising machinery.
Category-(b) candidate from §158 of the Knill survey.
-/

open Filter
open scoped BigOperators Topology

/-- Sites in the `L × L` periodic square lattice. -/
abbrev IsingSite (L : ℕ) [NeZero L] : Type := ZMod L × ZMod L

/-- Ising spins encoded as `±1`. -/
def spinValue (b : Bool) : ℝ := if b then 1 else -1

/-- Right neighbour in the periodic lattice. -/
def rightNeighbour {L : ℕ} [NeZero L] (p : IsingSite L) : IsingSite L :=
  ((p.1 + 1 : ZMod L), p.2)

/-- Upward neighbour in the periodic lattice. -/
def upNeighbour {L : ℕ} [NeZero L] (p : IsingSite L) : IsingSite L :=
  (p.1, (p.2 + 1 : ZMod L))

/-- Zero-field ferromagnetic Ising Hamiltonian on the periodic box. -/
noncomputable def isingEnergy (L : ℕ) [NeZero L] (σ : IsingSite L → Bool) : ℝ :=
  -((∑ p : IsingSite L, spinValue (σ p) * spinValue (σ (rightNeighbour p))) +
      ∑ p : IsingSite L, spinValue (σ p) * spinValue (σ (upNeighbour p)))

/-- Finite-volume partition function at inverse temperature `β`. -/
noncomputable def isingPartitionFunction (L : ℕ) [NeZero L] (β : ℝ) : ℝ :=
  ∑ σ : IsingSite L → Bool, Real.exp (-β * isingEnergy L σ)

/-- Finite-volume free energy density. -/
noncomputable def finiteIsingFreeEnergy (L : ℕ) [NeZero L] (β : ℝ) : ℝ :=
  Real.log (isingPartitionFunction L β) / (L : ℝ) ^ 2

/-- Free energy along positive side lengths `n+1`. -/
noncomputable def finiteIsingFreeEnergySeq (n : ℕ) (β : ℝ) : ℝ :=
  finiteIsingFreeEnergy (n + 1) β



end LeanEval.Analysis.IsingPhaseTransition
