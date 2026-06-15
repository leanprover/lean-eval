import Lean
import Lean.DeclarationRange

open Lean

structure SourceRange where
  startLine : Nat
  startColumn : Nat
  endLine : Nat
  endColumn : Nat
  deriving ToJson

structure ExtractedTheorem where
  declarationName : String
  module : String
  sourceRange : SourceRange
  /-- Names of declarations from the same module that appear (transitively) in the
  type or value of this theorem. Computed from the elaborated terms, so this captures
  uses introduced by typeclass synthesis (which the `.ilean` references metadata
  records as textual matches only). -/
  sameModuleDependencies : Array String
  /-- One of `"theorem"` (covers `.thmInfo` and `.opaqueInfo`), `"def"`, or
  `"instance"`. Drives whether the generator emits this hole in `theorem_names`
  or `definition_names` in the comparator config. -/
  kind : String
  deriving ToJson

def parseName (text : String) : Name :=
  text.splitOn "." |>.foldl Name.str .anonymous

def lastComponent? : Name → Option String
  | .str _ s => some s
  | .num p _ => lastComponent? p
  | .anonymous => none

def findDeclByBasename (env : Environment) (moduleName declName : Name) : IO Name := do
  let some moduleIdx := env.getModuleIdx? moduleName
    | throw <| IO.userError s!"Module '{moduleName}' is not present in the imported environment."
  let targetBasename := lastComponent? declName
  let mut foundNames := (#[] : Array Name)
  for (candidate, _) in env.constants do
    if env.getModuleIdxFor? candidate == some moduleIdx && lastComponent? candidate == targetBasename then
      foundNames := foundNames.push candidate
  match foundNames.size with
  | 1 => return foundNames[0]!
  | 0 => throw <| IO.userError s!"Declaration '{declName}' was not found in module '{moduleName}'."
  | _ => throw <| IO.userError s!"Declaration '{declName}' is ambiguous in module '{moduleName}'."

def resolveDeclName (env : Environment) (moduleName declName : Name) : IO Name := do
  let candidates :=
    if declName.isAnonymous then
      #[moduleName]
    else if declName == moduleName || moduleName.isPrefixOf declName then
      #[declName]
    else
      #[declName, moduleName ++ declName]
  for candidate in candidates do
    if env.find? candidate |>.isSome then
      return candidate
  findDeclByBasename env moduleName declName

/-- Last components of the coercion type classes. A coercion (`↑`/`⇑`) is
unfolded during elaboration, so the instance backing it never appears in the
elaborated term's `getUsedConstantsAsSet` — even when a kept helper's *source
text* relies on it (e.g. `T x` where `instCoeFun … : CoeFun …`). The generated
`ChallengeDeps.lean` reproduces source text, so it must carry these instances;
we recover them structurally rather than from the dependency closure. -/
def coercionClassLastComponents : Array String :=
  #["Coe", "CoeTC", "CoeHead", "CoeTail", "CoeHTCT", "CoeHTC", "CoeOut",
    "CoeDep", "CoeT", "CoeFun", "CoeSort"]

def isCoercionClassName (n : Name) : Bool :=
  match lastComponent? n with
  | some s => coercionClassLastComponents.contains s
  | none => false

/-- The head constant of a (possibly dependent) type's conclusion: strip leading
`∀`/`→` binders and return the application head. -/
partial def conclusionHead : Expr → Option Name
  | .forallE _ _ body _ => conclusionHead body
  | e => e.getAppFn.constName?

/-- Compute the set of names of declarations in `moduleName` that are reachable from
the type or value of `start`, following the same-module subgraph of the constant
dependency relation. The starting declaration itself is excluded from the result.

Internal compiler-generated auxiliaries (`._proof_1`, `._eq_1`, `.match_1`, …)
are traversed through — so genuine helpers they reference are still found — but
excluded from the returned set: they have no user source span to extract and are
regenerated automatically when their parent declaration is re-elaborated. (A
`noncomputable def` over a `Finset` sum, for instance, emits a `._proof_1` whose
prefix would otherwise be mistaken for a helper namespace to `open`.)

Coercion instances (see `coercionClassLastComponents`) are pulled in separately:
once the closure contains a constant, any same-module declaration whose type is a
coercion class mentioning that constant is added (and re-closed over). Such
instances vanish from elaborated terms but are still needed by the source text
the generator re-emits. They are detected structurally by the head of their
type's conclusion — `Lean.Meta.isInstanceCore` is unreliable against the bare
environment produced by `importModules` (the instance extension state is not
materialised), so we do not depend on it. -/
def collectSameModuleDependencies (env : Environment) (moduleName start : Name) :
    Array Name := Id.run do
  let some moduleIdx := env.getModuleIdx? moduleName | return #[]
  -- Same-module coercion providers, paired with the constants in their type.
  let mut coeInstances : Array (Name × Array Name) := #[]
  for (c, info) in env.constants do
    if env.getModuleIdxFor? c == some moduleIdx then
      if let some cls := conclusionHead info.type then
        if isCoercionClassName cls then
          coeInstances := coeInstances.push (c, info.type.getUsedConstants)
  let mut closure : NameSet := {}
  let mut stack : Array Name := #[start]
  let mut progress := true
  while progress do
    progress := false
    -- Direct dependency closure over the same-module subgraph.
    while !stack.isEmpty do
      let current := stack.back!
      stack := stack.pop
      if closure.contains current then continue
      closure := closure.insert current
      let some info := env.find? current | continue
      for c in info.getUsedConstantsAsSet do
        if env.getModuleIdxFor? c == some moduleIdx
            && c != current && !closure.contains c then
          stack := stack.push c
    -- Pull in coercion instances now reachable, then re-close.
    for (inst, typeConsts) in coeInstances do
      if closure.contains inst then continue
      if typeConsts.any closure.contains then
        stack := stack.push inst
        progress := true
  return (closure.erase start).toArray.filter (fun n => !n.isInternalDetail)

def extractTheorem (moduleNameText declNameText : String) : IO ExtractedTheorem := do
  let moduleName := parseName moduleNameText
  let declName := parseName declNameText
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := moduleName }] {}
  let resolvedDeclName ← resolveDeclName env moduleName declName
  let some constantInfo := env.find? resolvedDeclName
    | throw <| IO.userError s!"Resolved declaration '{resolvedDeclName}' disappeared unexpectedly."
  let some declRanges ← ({ env := env } : PPContext).runCoreM do
    findDeclarationRanges? resolvedDeclName
    | throw <| IO.userError s!"Declaration ranges for '{resolvedDeclName}' were not available."
  let sourceRange : SourceRange := {
    startLine := declRanges.range.pos.line
    startColumn := declRanges.range.pos.column
    endLine := declRanges.range.endPos.line
    endColumn := declRanges.range.endPos.column
  }
  let kind? : Option String := match constantInfo with
    | .thmInfo _ | .opaqueInfo _ => some "theorem"
    | .defnInfo _ =>
        if Lean.Meta.isInstanceCore env resolvedDeclName then some "instance" else some "def"
    | _ => none
  match kind? with
  | some kind =>
      let deps := collectSameModuleDependencies env moduleName resolvedDeclName
      return {
        declarationName := toString resolvedDeclName
        module := moduleNameText
        sourceRange := sourceRange
        sameModuleDependencies := deps.map toString
        kind := kind
      }
  | none =>
      throw <| IO.userError
        s!"Declaration '{resolvedDeclName}' has unsupported kind for an eval-problem hole."

def main (args : List String) : IO UInt32 := do
  let [moduleName, declName] := args
    | throw <| IO.userError "usage: extract_theorem <module> <declaration>"
  let result ← extractTheorem moduleName declName
  IO.println <| Json.compress <| toJson result
  return 0
