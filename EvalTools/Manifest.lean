import Lean
import EvalTools.Markers
import EvalTools.Subprocess

open Lean

namespace EvalTools

set_option autoImplicit false

/-- Path of the manifest, relative to the repository root. -/
def defaultManifestRelativePath : System.FilePath :=
  "manifests" / "problems.toml"

private def isAsciiAlnum (c : Char) : Bool :=
  c.isAlpha || c.isDigit

/-- Mirrors the Python `ID_PATTERN = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_-]*$")`. -/
private def isValidProblemId (s : String) : Bool :=
  !s.isEmpty
    && isAsciiAlnum s.front
    && s.all (fun c => isAsciiAlnum c || c == '_' || c == '-')

/-- Load and validate the manifest. Wraps `parseManifestMetadata` (which
already enforces required fields, non-empty holes, and `id` / hole-reference
uniqueness) and adds the ASCII `ID_PATTERN` check from
`scripts/generate_projects.py`. -/
def loadManifest (root : System.FilePath) : IO (Array EvalProblemMetadata) := do
  let manifestPath := root / defaultManifestRelativePath
  let contents ← IO.FS.readFile manifestPath
  match ← parseManifestMetadata contents manifestPath.toString with
  | .error err => throw <| IO.userError err
  | .ok entries =>
      for entry in entries do
        unless isValidProblemId entry.id do
          throw <| IO.userError
            s!"Problem id '{entry.id}' is invalid. Use only letters, digits, '_' or '-'."
      return entries

/-- Preserve the order of first occurrence (matches Python's `unique_modules`). -/
def uniqueModules (entries : Array EvalProblemMetadata) : Array String := Id.run do
  let mut seen : Std.HashSet String := {}
  let mut out : Array String := #[]
  for entry in entries do
    unless seen.contains entry.moduleName do
      seen := seen.insert entry.moduleName
      out := out.push entry.moduleName
  return out

/-- Result row from the `eval_inventory` tool. Mirrors
`scripts/generate_projects.py`'s `InventoryEntry`. -/
structure ManifestInventoryEntry where
  module : String
  declarationName : String
  basename : String
  kind : String
  deriving Inhabited

private def parseInventoryEntries (payload : String) :
    Except String (Array ManifestInventoryEntry) := do
  let json ← Json.parse payload
  let arr ← json.getArr?
  let mut out : Array ManifestInventoryEntry := #[]
  for raw in arr do
    let module ← raw.getObjValAs? String "module"
    let declarationName ← raw.getObjValAs? String "declarationName"
    let basename ← raw.getObjValAs? String "basename"
    let kind ← raw.getObjValAs? String "kind"
    out := out.push
      { module := module, declarationName := declarationName,
        basename := basename, kind := kind }
  return out

/-- Build the lake target and run the `eval_inventory` executable over every
module referenced by `entries`. -/
def runInventoryTool (root : System.FilePath) (modules : Array String) :
    IO (Array ManifestInventoryEntry) := do
  let _ ← runCmdCheckedCaptured "lake"
    (#["build"] ++ modules ++ #["eval_inventory"]) root
    "Failed to build Lean problem inventory tool"
  let binPath := root / ".lake" / "build" / "bin" / "eval_inventory"
  let out ← runCmdCheckedCaptured "lake"
    (#["env", binPath.toString] ++ modules) root
    "Lean problem inventory failed"
  match parseInventoryEntries out.stdout with
  | .ok entries => pure entries
  | .error err => throw <| IO.userError s!"Problem inventory returned invalid JSON: {err}"

/-- Match Python's `gp.validate_manifest_against_inventory`: ensure every
manifest hole resolves to exactly one `@[eval_problem]`-tagged declaration,
and every such declaration appears in the manifest. -/
def validateManifestAgainstInventory
    (root : System.FilePath) (entries : Array EvalProblemMetadata) : IO Unit := do
  let modules := uniqueModules entries
  let inventory ← runInventoryTool root modules
  let mut byModule : Std.HashMap String (Array ManifestInventoryEntry) := {}
  for inv in inventory do
    byModule := byModule.insert inv.module
      ((byModule.getD inv.module #[]).push inv)
  let mut matched : Std.HashSet String := {}
  for problem in entries do
    let moduleInventory := byModule.getD problem.moduleName #[]
    for hole in problem.holes do
      let candidates := moduleInventory.filter fun inv =>
        inv.basename == hole || inv.declarationName == hole
      if candidates.isEmpty then
        throw <| IO.userError
          s!"Manifest entry '{problem.id}' references hole '{hole}' which has no @[eval_problem] declaration in module '{problem.moduleName}'."
      if candidates.size > 1 then
        throw <| IO.userError
          s!"Manifest entry '{problem.id}' hole '{hole}' is ambiguous in module '{problem.moduleName}'. Use a fully qualified name."
      matched := matched.insert candidates[0]!.declarationName
  let untracked := inventory.filterMap fun inv =>
    if matched.contains inv.declarationName then none else some inv.declarationName
  if !untracked.isEmpty then
    let sorted := untracked.qsort (· < ·)
    let joined := ", ".intercalate sorted.toList
    throw <| IO.userError
      s!"Tagged @[eval_problem] declaration(s) are missing from manifests/problems.toml: {joined}"

end EvalTools
