import EvalTools.ProblemSources
import EvalTools.Markers

open Lean

namespace EvalTools

open LeanEvalGenerator.Core

set_option autoImplicit false

private def sourcesByName (sources : Array ProblemSourceModule) :
    Std.HashMap Name ProblemSourceModule :=
  sources.foldl (fun m source => m.insert source.name source) ∅

/-- Mark `name` and everything it transitively imports as reached. Imports that
name no module in `byName` (Mathlib, `EvalTools.Markers`, ...) are recorded but
not followed. -/
private partial def markReachable (byName : Std.HashMap Name ProblemSourceModule)
    (reached : Std.HashSet Name) (name : Name) : Std.HashSet Name :=
  if reached.contains name then
    reached
  else
    let reached := reached.insert name
    match byName[name]? with
    | none => reached
    | some source => source.imports.foldl (markReachable byName) reached

/-- The modules of `sources` that are neither listed in `roots` nor reachable
from `roots` by following imports. Order follows `sources`. -/
def unreachableModules (sources : Array ProblemSourceModule) (roots : Array Name) :
    Array Name :=
  let byName := sourcesByName sources
  let reached := roots.foldl (markReachable byName) ∅
  sources.filterMap fun source =>
    if reached.contains source.name then none else some source.name

/-- Fail unless every `.lean` file under `LeanEval/` is reachable from the
manifest: either named by some entry's `module` field, or imported (directly or
transitively) by a module that is.

Nothing else walks the problem sources, so a module the manifest cannot reach is
never compiled and never validated; it can carry a broken statement and leave CI
green. See https://github.com/leanprover/lean-eval/issues/519.

This is a header-level check: it parses imports rather than building anything,
so it costs no build time and runs before the inventory cross-check. -/
def checkProblemModuleCoverage
    (root : System.FilePath) (entries : Array EvalProblemMetadata) : IO Unit := do
  let sources ← loadProblemSourceModules root
  let known := sources.foldl (fun s source => s.insert source.name) (∅ : Std.HashSet Name)
  let missing := entries.filterMap fun entry =>
    if known.contains (parseModuleName entry.moduleName) then none
    else some s!"  {entry.moduleName} (manifests/problems/{entry.id}.toml)"
  if !missing.isEmpty then
    throw <| IO.userError <|
      "Manifest entries name modules that have no source file under `LeanEval/`:\n"
        ++ "\n".intercalate missing.toList
        ++ "\nCheck the `module` field for a typo, or add the missing file."
  let unreachable := unreachableModules sources (entries.map (parseModuleName ·.moduleName))
  if !unreachable.isEmpty then
    let byName := sourcesByName sources
    let described := unreachable.map fun name =>
      match byName[name]? with
      | some source => s!"  {name} ({source.path})"
      | none => s!"  {name}"
    throw <| IO.userError <|
      "No manifest entry reaches the following module(s), so CI never builds them:\n"
        ++ "\n".intercalate described.toList
        ++ "\nEvery file under `LeanEval/` must be named by the `module` field of some \
            `manifests/problems/<id>.toml`, or be imported (directly or transitively) by a \
            module that is. If you did write a manifest for one of these, check that it sits \
            in `manifests/problems/` and that its name ends in `.toml`; if the file is a \
            leftover, delete it."

end EvalTools
