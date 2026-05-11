import EvalTools.Manifest

namespace EvalTools

set_option autoImplicit false

private def hasSubstr (haystack pattern : String) : Bool :=
  (haystack.find? pattern).isSome

private def isDisallowedWarning (line : String) : Bool :=
  hasSubstr line "warning:" && !hasSubstr line "declaration uses `sorry`"

/-- Implementation of `lake exe lean-eval check-problem-build`. Builds every
manifest module via `lake build`, then scans captured output for warnings
other than the expected `declaration uses \`sorry\`` warnings the problem
modules emit by design. -/
def runCheckProblemBuild (root : System.FilePath) : IO UInt32 := do
  try
    let entries ← loadManifest root
    let modules := uniqueModules entries
    let output ← runCmdCheckedCaptured "lake" (#["build"] ++ modules) root
      "Problem module build failed"
    let combined :=
      [output.stdout, output.stderr].filter (! ·.isEmpty) |> String.intercalate "\n"
    let lines := combined.splitOn "\n"
    let disallowed := lines.filter isDisallowedWarning
    if !disallowed.isEmpty then
      IO.eprintln "Disallowed build warnings found:"
      for line in disallowed do
        IO.eprintln line
      return (1 : UInt32)
    IO.println "Problem modules built cleanly aside from expected `sorry` warnings."
    return (0 : UInt32)
  catch err =>
    IO.eprintln err
    return (1 : UInt32)

end EvalTools
