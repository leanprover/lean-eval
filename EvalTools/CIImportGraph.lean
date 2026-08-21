import EvalTools.ModuleCoverage

open Lean

namespace EvalTools

set_option autoImplicit false

private def sourceToJson (source : ProblemSourceModule) : Json :=
  Json.mkObj [
    ("path", source.path),
    ("module", toString source.name),
    ("imports", Json.arr (source.imports.map fun name => Json.str (toString name)))
  ]

/-- Emit the repository-local Lean import graph for the CI selector. Header
syntax is parsed by Lean itself through `loadProblemSourceModules`. -/
def runCIImportGraph (root : System.FilePath) : IO UInt32 := do
  try
    let sources ← loadProblemSourceModules root
    IO.println <| Json.compress <| Json.arr (sources.map sourceToJson)
    return 0
  catch err =>
    IO.eprintln err
    return 1

end EvalTools

def main (args : List String) : IO UInt32 := do
  unless args.isEmpty do
    IO.eprintln "ci_import_graph does not accept arguments."
    return 1
  EvalTools.runCIImportGraph (← IO.currentDir)
