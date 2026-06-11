import EvalTools.Generate

open EvalTools

set_option autoImplicit false

private def assertEq {α : Type} [BEq α] [Repr α] (label : String)
    (actual expected : α) : Option String :=
  if actual == expected then none
  else some s!"{label}: expected {repr expected}, got {repr actual}"

private def check (label : String) (passes fails : IO.Ref Nat)
    (f : IO (Option String)) : IO Unit := do
  match ← f.toBaseIO with
  | .ok none => IO.println s!"PASS: {label}"; passes.modify (· + 1)
  | .ok (some reason) =>
      IO.eprintln s!"FAIL: {label} — {reason}"
      fails.modify (· + 1)
  | .error err =>
      IO.eprintln s!"FAIL: {label} — unexpected exception: {err}"
      fails.modify (· + 1)

def main : IO UInt32 := do
  let passes ← IO.mkRef 0
  let fails ← IO.mkRef 0

  check "isScopedOpenLine: open Foo is top-level" passes fails do
    pure <| assertEq "scoped" (isScopedOpenLine "open Foo") false

  check "isScopedOpenLine: open scoped Classical is top-level" passes fails do
    pure <| assertEq "scoped" (isScopedOpenLine "open scoped Classical") false

  check "isScopedOpenLine: open Foo in is scoped" passes fails do
    pure <| assertEq "scoped" (isScopedOpenLine "open Foo in") true

  check "isScopedOpenLine: open Foo in body is scoped" passes fails do
    pure <| assertEq "scoped" (isScopedOpenLine "open Foo in rfl") true

  check "isScopedOpenLine: open scoped Classical in is scoped" passes fails do
    pure <| assertEq "scoped" (isScopedOpenLine "open scoped Classical in") true

  check "isScopedOpenLine: open Foo.In is top-level" passes fails do
    pure <| assertEq "scoped" (isScopedOpenLine "open Foo.In") false

  check "isScopedOpenLine: non-open line is not scoped" passes fails do
    pure <| assertEq "scoped" (isScopedOpenLine "theorem foo : True := trivial") false

  -- A trailing `--` comment that happens to contain the word `in` must not
  -- cause a top-level `open` to be misclassified as scoped.
  check "isScopedOpenLine: trailing comment with 'in' is not scoped" passes fails do
    pure <| assertEq "scoped"
      (isScopedOpenLine "open Foo -- used in later declarations") false

  check "isScopedOpenLine: real scoped open with comment is scoped" passes fails do
    pure <| assertEq "scoped"
      (isScopedOpenLine "open Foo in expr -- comment") true

  -- Block comment containing `in` must not trigger a false positive.
  check "isScopedOpenLine: block comment with 'in' is not scoped" passes fails do
    pure <| assertEq "scoped"
      (isScopedOpenLine "open Foo /- mentions in here -/") false

  check "isScopedOpenLine: nested block comment is stripped" passes fails do
    pure <| assertEq "scoped"
      (isScopedOpenLine "open Foo /- outer /- inner in -/ still in -/") false

  check "isScopedOpenLine: real scoped open with block comment is scoped" passes fails do
    pure <| assertEq "scoped"
      (isScopedOpenLine "open Foo /- note -/ in expr") true

  -- Regression for https://github.com/leanprover/lean-eval/issues/277:
  -- `open Classical in` inside an earlier def body must not leak into the
  -- collected context-open block.
  check "extractContextOpens skips open … in inside def bodies" passes fails do
    let source :=
      "import Mathlib\n" ++
      "namespace LeanEval.Algebra\n" ++
      "open Polynomial\n" ++
      "\n" ++
      "noncomputable def sturmAux : Nat → Nat\n" ++
      "  | 0       => 0\n" ++
      "  | (n + 1) =>\n" ++
      "    open Classical in\n" ++
      "    if n = 0 then 1 else sturmAux n\n" ++
      "\n" ++
      "theorem target : True := trivial\n" ++
      "end LeanEval.Algebra\n"
    let extracted : ExtractedTheorem := {
      declarationName := "LeanEval.Algebra.target"
      module := "LeanEval.Algebra"
      startLine := 11, startColumn := 0
      endLine := 11, endColumn := 30
      sameModuleDependencies := #[]
      kind := "theorem"
    }
    let block ← extractContextOpens "demo" "demo.lean" source (some extracted)
      (includeNamespaces := true)
    -- The block should mention top-level opens but not the scoped `open Classical in`.
    let hasOpenPolynomial := (block.find? "open Polynomial").isSome
    let hasOpenClassicalIn := (block.find? "open Classical in").isSome
    pure <| assertEq "top-level open kept" hasOpenPolynomial true |>.or
      (assertEq "scoped open dropped" hasOpenClassicalIn false)

  -- Multi-line scoped open: `open Foo` on one line, `in` on the next.
  -- The whole thing is scoped to one command and must not be hoisted out.
  check "extractContextOpens skips multi-line open … in" passes fails do
    let source :=
      "import Mathlib\n" ++
      "namespace Demo\n" ++
      "open Polynomial\n" ++
      "\n" ++
      "noncomputable def helper : Nat :=\n" ++
      "  open Classical\n" ++
      "    in if 0 = 0 then 1 else 2\n" ++
      "\n" ++
      "theorem target : True := trivial\n" ++
      "end Demo\n"
    let extracted : ExtractedTheorem := {
      declarationName := "Demo.target"
      module := "Demo"
      startLine := 9, startColumn := 0
      endLine := 9, endColumn := 30
      sameModuleDependencies := #[]
      kind := "theorem"
    }
    let block ← extractContextOpens "demo" "demo.lean" source (some extracted)
      (includeNamespaces := true)
    let hasOpenPolynomial := (block.find? "open Polynomial").isSome
    let hasOpenClassical := (block.find? "open Classical").isSome
    pure <| assertEq "top-level open kept" hasOpenPolynomial true |>.or
      (assertEq "scoped open (multi-line) dropped" hasOpenClassical false)

  -- A real top-level `open` whose trailing comment mentions `in` must be kept.
  check "extractContextOpens keeps top-level open with 'in' in comment" passes fails do
    let source :=
      "import Mathlib\n" ++
      "namespace Demo\n" ++
      "open Polynomial -- used in later declarations\n" ++
      "\n" ++
      "theorem target : True := trivial\n" ++
      "end Demo\n"
    let extracted : ExtractedTheorem := {
      declarationName := "Demo.target"
      module := "Demo"
      startLine := 5, startColumn := 0
      endLine := 5, endColumn := 30
      sameModuleDependencies := #[]
      kind := "theorem"
    }
    let block ← extractContextOpens "demo" "demo.lean" source (some extracted)
      (includeNamespaces := true)
    let hasOpenPolynomial := (block.find? "open Polynomial").isSome
    pure <| assertEq "top-level open with 'in' comment kept" hasOpenPolynomial true

  check "injectSolutionHoleModifiers: plain def gains both modifiers" passes fails do
    pure <| assertEq "rewritten"
      (injectSolutionHoleModifiers "def foo : Nat := " "foo")
      (some "@[reducible] noncomputable def foo : Nat := ")

  check "injectSolutionHoleModifiers: existing noncomputable is folded" passes fails do
    pure <| assertEq "rewritten"
      (injectSolutionHoleModifiers "noncomputable def foo : Nat := " "foo")
      (some "@[reducible] noncomputable def foo : Nat := ")

  check "injectSolutionHoleModifiers: instance with doc comment" passes fails do
    pure <| assertEq "rewritten"
      (injectSolutionHoleModifiers
        "/-- doc -/\nnoncomputable instance instFoo : Inhabited Nat := " "instFoo")
      (some "/-- doc -/\n@[reducible] noncomputable instance instFoo : Inhabited Nat := ")

  -- The word `noncomputable` at the end of a doc comment is not a modifier
  -- and must not be stripped.
  check "injectSolutionHoleModifiers: doc comment mentioning noncomputable" passes fails do
    pure <| assertEq "rewritten"
      (injectSolutionHoleModifiers "/-- might be noncomputable -/\ndef foo : Nat := " "foo")
      (some "/-- might be noncomputable -/\n@[reducible] noncomputable def foo : Nat := ")

  check "injectSolutionHoleModifiers: no def/instance/abbrev anchor" passes fails do
    pure <| assertEq "rewritten"
      (injectSolutionHoleModifiers "theorem foo : True := " "foo")
      none

  let passCount ← passes.get
  let failCount ← fails.get
  IO.println s!"\n{passCount} passed, {failCount} failed."
  return if failCount == 0 then 0 else 1
