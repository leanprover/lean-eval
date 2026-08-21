import Mathlib.Analysis.Real.Sqrt
import Submission
import ChallengeDeps
/-!
# Quantifier elimination for real closed fields

## The task

Work in the first-order language of ordered rings: `Term`s are built from variables, integer
constants, `+`, `*` and `-`, and `Formula`s are built from the atoms `<` and `=` using `⊥`, `→`
and `∀`. `Formula.Holds` interprets a formula in `ℝ` under an environment assigning a real to
each variable, and `Formula.IsQF` says that a formula contains no quantifier.

Implement `qe`, which converts an arbitrary formula into an equivalent quantifier-free one, and
prove that it does. `isQF_qe` says the output contains no quantifier. `holds_qe` says the input
and the output have the same truth value in every environment. No separate free-variable
condition is needed for semantic equivalence, although the output may syntactically mention
additional variables in vacuous expressions such as `x = x`.

For example, `∃ x. x * x = a` has the de Bruijn form

    Formula.ex (.eq (.mul (.var 0) (.var 0)) (.var 1))

with `a` free, and `qe` must return something equivalent to `¬ (a < 0)`, such as

    Formula.not (.lt (.var 0) (.const 0))

This is the point at which real closedness does the work: the equivalence fails over `ℚ`.

Tarski proved that such a `qe` exists, which is what makes the theory decidable: to decide a
sentence, run `qe` and evaluate the resulting closed quantifier-free formula. The
Cohen-Hörmander route has a comparatively small formalization footprint. Cylindrical algebraic
decomposition is an important practical route and has also been formalized in Coq; see
Mahboubi's certified CAD work and the current MathComp CAD development. Cohen and Mahboubi's
quantifier-elimination development instead follows an algebraic pseudo-remainder route.

The problem is posed over `ℝ` for concreteness. Tarski's theorem holds over an arbitrary real
closed field. Generalising `holds_qe` in that direction would require a more abstract algebraic
development than the concrete Mathlib API over `ℝ` used here.

## Design notes

The trusted vocabulary is deliberately small and purely syntactic. Variables are raw de Bruijn
indices and environments are total functions `Nat → ℝ`, so there is no well-scopedness
bookkeeping to do.

`isQF_qe` and `holds_qe` are jointly load-bearing and neither can be dropped:

* with only `isQF_qe`, take `qe := fun _ => .fals`;
* with only `holds_qe`, take `qe := id`.

Terms and quantifier-free formulas are enumerable, but enumerating candidates does not provide
a shortcut: recognizing which candidate is equivalent to the input already requires the
substantive quantifier-elimination argument. There is likewise no `Classical.choice` shortcut,
because the existence proof one would have to exhibit before choosing a quantifier-free
equivalent is Tarski's theorem itself.

A decision procedure `valid? : Formula → Bool` with `valid? φ = true ↔ ∀ env, φ.Holds env` was
considered as a further hole and rejected: `noncomputable def valid? φ := decide (∀ env,
φ.Holds env)` satisfies it with a one-line proof. Declaring it a plain `def` does make Lean
reject that, but `noncomputable` is recorded in a separate environment extension rather than in
the `ConstantInfo`, so a checker comparing name, type, universe levels and safety will not see
the difference.
-/

namespace LeanEval
namespace ProgramVerification
namespace RealClosedFieldQE

/-! ## Syntax -/





namespace Formula



/-- Truth. -/
def tru : Formula := .not .fals

/-- Disjunction. -/
def or (φ ψ : Formula) : Formula := .imp φ.not ψ

/-- Conjunction. -/
def and (φ ψ : Formula) : Formula := (φ.imp ψ.not).not



/-!
Under the classical logic available in this problem, these derived connectives have their
usual semantics under `Formula.Holds`.
-/

end Formula

/-! ## Semantics -/









/-! ## The problem -/

/--
Quantifier elimination: `qe φ` is a quantifier-free formula equivalent to `φ` over `ℝ` in
every environment. Its syntax may mention additional variables vacuously.
-/
@[reducible] noncomputable def qe (φ : Formula) : Formula := Submission.LeanEval.ProgramVerification.RealClosedFieldQE.qe φ

/-- The output of `qe` is quantifier free. -/
theorem isQF_qe (φ : Formula) : (qe φ).IsQF := Submission.LeanEval.ProgramVerification.RealClosedFieldQE.isQF_qe φ

/-- The output of `qe` is equivalent to its input, under every environment. -/
theorem holds_qe (φ : Formula) (env : Nat → ℝ) :
    (qe φ).Holds env ↔ φ.Holds env := Submission.LeanEval.ProgramVerification.RealClosedFieldQE.holds_qe φ env

/--
Anti-vacuity guard for the semantics and de Bruijn convention: a real number is a square
exactly when it is nonnegative.
-/
theorem holds_ex_sq (env : Nat → ℝ) :
    (Formula.ex (.eq (.mul (.var 0) (.var 0)) (.var 1))).Holds env ↔
      (Formula.not (.lt (.var 0) (.const 0))).Holds env := Submission.LeanEval.ProgramVerification.RealClosedFieldQE.holds_ex_sq env

end RealClosedFieldQE
end ProgramVerification
end LeanEval
