import Lean

open Lean

namespace EvalTools

set_option autoImplicit false

/-- Directory holding the trusted problem sources, relative to the repository
root. Its module prefix is the directory name. -/
def problemSourceRelativePath : System.FilePath := "LeanEval"

/-- A `.lean` file under `LeanEval/`, together with the modules its header
imports.

Module identity is a `Name`, not a string: `LeanEval/Foo/Bar.lean` is
`LeanEval.Foo.Bar` while `LeanEval/Foo.Bar.lean` is `LeanEval.«Foo.Bar»`, and
flattening either to text would conflate two distinct files. -/
structure ProblemSourceModule where
  /-- Fully qualified module name, for example
  `LeanEval.Geometry.JacobianChallenge`. -/
  name : Name
  /-- Path of the file, relative to the repository root. -/
  path : String
  /-- The modules named in the file's `import` header. -/
  imports : Array Name
  deriving Inhabited, Repr

/-- Recursively collect the `.lean` files under `dir`, reading each header for
its imports. `relDir` and `modulePrefix` describe `dir` itself. -/
private partial def collectSourceModules (dir : System.FilePath) (relDir : String)
    (modulePrefix : Name) : IO (Array ProblemSourceModule) := do
  let entries := (← dir.readDir).qsort fun a b => a.fileName < b.fileName
  let mut out : Array ProblemSourceModule := #[]
  for entry in entries do
    let relPath := s!"{relDir}/{entry.fileName}"
    -- `symlinkMetadata` rather than `isDir`: the latter follows links, so a
    -- directory symlink could duplicate a subtree under a second module prefix,
    -- or point at an ancestor and recurse forever.
    match (← entry.path.symlinkMetadata).type with
    | .symlink =>
        throw <| IO.userError
          s!"`{relPath}` is a symbolic link. Problem sources must be regular files and \
             directories, so that a file's path determines its module name."
    | .dir =>
        out := out ++ (← collectSourceModules entry.path relPath (modulePrefix.str entry.fileName))
    | _ =>
        if entry.path.extension == some "lean" then
          let stem := (entry.fileName.dropEnd 5).toString
          let (header, _, messages) ← Lean.Elab.parseImports (← IO.FS.readFile entry.path)
            entry.path.toString
          if messages.hasErrors then
            throw <| IO.userError s!"Invalid import header in {relPath}: {← messages.toList.toArray.mapM (·.toString)}"
          out := out.push
            { name := modulePrefix.str stem
              path := relPath
              imports := header.map (·.module) }
  return out

/-- Load every source module under `LeanEval/`, using Lean's own module-header
parser to identify imports. This is shared by module-coverage validation and
the CI dependency selector so they cannot disagree about Lean import syntax. -/
def loadProblemSourceModules (root : System.FilePath) : IO (Array ProblemSourceModule) := do
  let sourceRoot := root / problemSourceRelativePath
  unless ← sourceRoot.isDir do
    throw <| IO.userError
      s!"Problem source directory `{sourceRoot}` does not exist or is not a directory."
  let prefixName := problemSourceRelativePath.toString
  collectSourceModules sourceRoot prefixName (.str .anonymous prefixName)

end EvalTools
