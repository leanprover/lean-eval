import Lean

open Lean

/-- Compare canonical paths on directory boundaries. -/
private def withinWorkspace (roots : Array System.FilePath) (path : System.FilePath) : Bool :=
  roots.any fun root => path == root ||
    path.toString.startsWith (root.toString ++ System.FilePath.pathSeparator.toString)

/-- Drop workspace/cache search directories, including relative paths and symlink aliases.
Nonexistent directories are omitted rather than allowing a build to create them later. -/
private def trustedSearchPath (roots : Array System.FilePath) (value : String) : IO String := do
  let mut dirs : System.SearchPath := []
  for dir in System.SearchPath.parse value do
    if dir.toString.isEmpty then continue
    try
      let dir ← IO.FS.realPath dir
      if !(withinWorkspace roots dir) && (← dir.isDir) then
        dirs := dirs ++ [dir]
    catch _ => pure ()
  return dirs.toString

/-- Resolve a tool using only the trusted search path, and reject workspace overrides. -/
private def trustedTool (roots : Array System.FilePath)
    (env : Array (String × Option String)) (envName fallback : String) :
    IO String := do
  let tool := (← IO.getEnv envName).getD fallback
  let result ← IO.Process.output {
    cmd := "which"
    args := #["--", tool]
    env
  }
  if result.exitCode != 0 then
    throw <| IO.userError s!"Cannot find trusted tool for {envName}: {tool}"
  let resolved ← IO.FS.realPath result.stdout.trimAscii.toString
  if withinWorkspace roots resolved then
    throw <| IO.userError s!"{envName} must point outside the evaluation workspace and its writable cache: {resolved}"
  return resolved.toString

/-- Invoke comparator on this workspace, forcing the external nanoda kernel on.

nanoda is a global requirement of the eval, not a per-problem option: every
solution must be accepted by comparator **and** replayed through nanoda's
independent kernel. Rather than encode that in each workspace's `config.json`,
this harness reads the committed config, overrides `enable_nanoda := true`, and
hands the result to comparator — so nanoda runs regardless of what the file on
disk says. This mirrors the comparator-live "gold standard" setup, which forces
nanoda at the invocation site and leaves project configs untouched.

Lake has already supplied LEAN_PATH when it starts this executable. Before
elaboration, remove workspace paths from executable/library lookup and pin all
comparator tools to absolute paths outside the workspace and its writable cache. Comparator's later
supervisor invocations must not resolve tools from submission-writable `.lake`. -/
def main : IO UInt32 := do
  let comparatorBin := (← IO.getEnv "COMPARATOR_BIN").getD "comparator"
  try
    let workspace ← IO.FS.realPath (← IO.currentDir)
    let roots := #[workspace, ← IO.FS.realPath (workspace / ".lake")]
    let path ← trustedSearchPath roots ((← IO.getEnv "PATH").getD "")
    if path.isEmpty then
      throw <| IO.userError "No trusted executable search directories remain"
    let mut env := #[("PATH", some path)]
    for envName in #["LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"] do
      if let some value ← IO.getEnv envName then
        let value ← trustedSearchPath roots value
        env := env.push (envName, if value.isEmpty then none else some value)
    let comparator ← trustedTool roots env "COMPARATOR_BIN" "comparator"
    let landrun ← trustedTool roots env "COMPARATOR_LANDRUN" "landrun"
    let exporter ← trustedTool roots env "COMPARATOR_LEAN4EXPORT" "lean4export"
    let nanoda ← trustedTool roots env "COMPARATOR_NANODA" "nanoda_bin"
    env := env ++ #[
      ("COMPARATOR_LANDRUN", some landrun),
      ("COMPARATOR_LEAN4EXPORT", some exporter),
      ("COMPARATOR_NANODA", some nanoda)
    ]
    let configText ← IO.FS.readFile "config.json"
    let config ← IO.ofExcept (Json.parse configText)
    let config := config.setObjVal! "enable_nanoda" (Json.bool true)
    IO.FS.withTempFile fun handle enforcedPath => do
      handle.putStr config.pretty
      handle.flush
      let child ← IO.Process.spawn {
        cmd := comparator
        args := #[enforcedPath.toString]
        env
      }
      child.wait
  catch err =>
    IO.eprintln s!"Failed to run comparator via `{comparatorBin}`."
    IO.eprintln "Install comparator, landrun, lean4export, and nanoda_bin outside this workspace, on PATH or through the COMPARATOR_* overrides."
    IO.eprintln "See the root repository README for comparator setup details, including landrun, lean4export, and nanoda."
    IO.eprintln s!"Original error: {err}"
    pure 1
