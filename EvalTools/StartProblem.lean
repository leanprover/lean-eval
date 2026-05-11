import Cli

open Cli

namespace EvalTools

set_option autoImplicit false

/-- Recursively copy `src` (a regular file or a directory) to `dst`, following
symlinks. Mirrors the subset of `shutil.copytree(symlinks=False)` semantics
the Python `start_problem.py` relied on. File permission bits are not
preserved (Lean's `IO.FS.Metadata` doesn't expose them); committed
`generated/` contents contain no executable files, so this matches the
Python behaviour in practice. -/
partial def copyTree (src dst : System.FilePath) : IO Unit := do
  -- `FilePath.metadata` follows symlinks, so `.symlink` is unreachable here.
  let info ← src.metadata
  match info.type with
  | .dir =>
      IO.FS.createDirAll dst
      for entry in (← src.readDir) do
        copyTree entry.path (dst / entry.fileName)
  | .file | .symlink | .other =>
      if let some parent := dst.parent then
        IO.FS.createDirAll parent
      let bytes ← IO.FS.readBinFile src
      IO.FS.writeBinFile dst bytes

/-- Implementation of `lake exe lean-eval start-problem`: copy a generated
single-problem workspace to a destination directory so participants have a
clean local starting point.

Both `source` and `destination` accept separate effective and display
representations: the effective `FilePath` is what we read/write, while the
display `String` is what we print, so output text stays as compact as the
Python script's (relative-to-repo-root) output. -/
def runStartProblem
    (sourcePath : System.FilePath) (sourceDisplay : String)
    (destinationPath : System.FilePath) (destinationDisplay : String) :
    IO UInt32 := do
  if !(← sourcePath.isDir) then
    IO.eprintln s!"Problem workspace not found: {sourceDisplay}"
    return 1
  if ← destinationPath.pathExists then
    IO.eprintln s!"Destination already exists: {destinationDisplay}"
    return 1
  if let some parent := destinationPath.parent then
    IO.FS.createDirAll parent
  copyTree sourcePath destinationPath
  IO.println s!"Created workspace: {destinationDisplay}"
  IO.println "Next steps:"
  IO.println s!"  cd {destinationDisplay}"
  IO.println "  lake update"
  IO.println "  lake test"
  return 0

end EvalTools
