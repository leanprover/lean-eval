import Lean

/- Parse headers without loading the imported libraries or running submission code. -/
def main (args : List String) : IO Unit := do
  let [pathsFile] := args
    | throw <| IO.userError "usage: dependency_imports.lean <JSON file of source paths>"
  let paths ← IO.ofExcept <|
    (Lean.Json.parse (← IO.FS.readFile pathsFile)).bind (Lean.fromJson? (α := Array String))
  let mut imports : Array (String × Array String) := #[]
  for path in paths do
    let (header, _, messages) ← Lean.Elab.parseImports (← IO.FS.readFile path) path
    if messages.hasErrors then
      -- Comparator reports malformed solver headers as ordinary proof failures.
      IO.eprintln s!"Skipping malformed import header in {path}; the Lean build will report it"
      continue
    for imp in header do
      let name := imp.module.toString
      unless imports.any (·.1 == name) do
        let parts := imp.module.components.toArray.map fun component =>
          match component with
          | .str _ s => s
          | .num _ n => toString n
          | .anonymous => ""
        imports := imports.push (name, parts)
  IO.println <| Lean.Json.compress <| Lean.toJson imports
