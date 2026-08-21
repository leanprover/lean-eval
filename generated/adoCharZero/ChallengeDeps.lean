import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean

namespace LeanEval.RepresentationTheory.AdoIwasawa

/-!
# Ado's theorem and the Ado–Iwasawa theorem

These problems ask for a faithful finite-dimensional representation of a
finite-dimensional Lie algebra. The first assumes that the base field has
characteristic zero; the second makes no assumption on its characteristic and
therefore subsumes the first. They remain separate benchmark entries because
the characteristic-zero proof is a substantial, distinct milestone.
-/

universe u v

/-- Endomorphisms carry the commutator Lie bracket used in the representation
targets below. Mathlib exposes this as a local instance, but the workspace
generator carries named same-module dependencies rather than `attribute`
commands, so a named instance is needed in generated challenge workspaces. -/
instance moduleEndLieRing (K : Type u) (V : Type v)
    [Field K] [AddCommGroup V] [Module K V] :
    LieRing (Module.End K V) :=
  LieRing.ofAssociativeRing

variable {K L : Type u} [Field K] [LieRing L] [LieAlgebra K L]





end LeanEval.RepresentationTheory.AdoIwasawa
