import Lake.Toml
import Lake.Util.Message
import Lean
import EvalTools.Manifest
import EvalTools.Markers
import EvalTools.Subprocess

set_option linter.deprecated false

open Lean
open Lean.Parser
open Lake
open Lake.Toml

namespace EvalTools

set_option autoImplicit false

/-! ## Constants -/

def fixedAxioms : Array String :=
  #["propext", "Quot.sound", "Classical.choice"]

def expectedFiles : Array String := #[
  "README.md",
  "lean-toolchain",
  "lakefile.toml",
  "ChallengeDeps.lean",
  "Challenge.lean",
  "Solution.lean",
  "Submission.lean",
  "Submission/Helpers.lean",
  "WorkspaceTest.lean",
  "config.json",
  "holes.json"
]

def ignoredPathNames : Array String := #[".lake", "build", ".cache", "lake-manifest.json"]

/-! ## Workspace test template -/

def loadWorkspaceTestTemplate (root : System.FilePath) : IO String :=
  IO.FS.readFile (root / "templates" / "WorkspaceTest.lean")

/-! ## Mathlib dependency -/

structure DependencySpec where
  name : String
  git : String
  rev : String
  deriving Inhabited

private structure RawRequire where
  name : String
  git : Option String := none
  rev : Option String := none
  deriving Inhabited

private instance : DecodeToml RawRequire where
  decode v := do
    let t ← v.decodeTable
    let name : String ← t.decode `name
    let git? : Option String ← t.decode? `git
    let rev? : Option String ← t.decode? `rev
    return { name := name, git := git?, rev := rev? }

def loadRootMathlibDependency (root : System.FilePath) : IO DependencySpec := do
  let path := root / "lakefile.toml"
  let contents ← IO.FS.readFile path
  let inputCtx := mkInputContext contents path.toString
  let table ←
    match (← Lake.Toml.loadToml inputCtx |>.toBaseIO) with
    | .ok table => pure table
    | .error err => throw <| IO.userError (← Lake.mkMessageLogString err)
  let decoded :
      EStateM.Result Unit (Array DecodeError) (Array RawRequire) :=
    (Lake.Toml.Table.decode (α := Array RawRequire) table `require).run #[]
  let requires ←
    match decoded with
    | .ok arr errors =>
        if errors.isEmpty then pure arr
        else throw <| IO.userError (decodeErrorsToString errors)
    | .error _ errors =>
        throw <| IO.userError (decodeErrorsToString errors)
  let mathlib := requires.filter fun r => r.name == "mathlib"
  if mathlib.isEmpty then
    throw <| IO.userError s!"Could not find a mathlib dependency in {path}"
  if mathlib.size > 1 then
    throw <| IO.userError s!"Found multiple mathlib dependencies in {path}"
  let entry := mathlib[0]!
  let git ← match entry.git with
    | some g =>
        let g := g.trim
        if g.isEmpty then
          throw <| IO.userError s!"mathlib dependency in {path} is missing a non-empty 'git' field"
        else pure g
    | none =>
        throw <| IO.userError s!"mathlib dependency in {path} is missing a non-empty 'git' field"
  let rev ← match entry.rev with
    | some r =>
        let r := r.trim
        if r.isEmpty then
          throw <| IO.userError s!"mathlib dependency in {path} is missing a non-empty 'rev' field"
        else pure r
    | none =>
        throw <| IO.userError s!"mathlib dependency in {path} is missing a non-empty 'rev' field"
  return { name := "mathlib", git := git, rev := rev }

/-! ## ExtractedTheorem (subprocess result) -/

structure ExtractedTheorem where
  declarationName : String
  module : String
  startLine : Nat
  startColumn : Nat
  endLine : Nat
  endColumn : Nat
  sameModuleDependencies : Array String
  kind : String
  deriving Inhabited

private def parseExtractedTheorem (payload : String) : Except String ExtractedTheorem := do
  let json ← Json.parse payload
  let declarationName ← json.getObjValAs? String "declarationName"
  let module ← json.getObjValAs? String "module"
  let kind ← json.getObjValAs? String "kind"
  let range ← json.getObjVal? "sourceRange"
  let startLine ← range.getObjValAs? Nat "startLine"
  let startColumn ← range.getObjValAs? Nat "startColumn"
  let endLine ← range.getObjValAs? Nat "endLine"
  let endColumn ← range.getObjValAs? Nat "endColumn"
  let depNames : Array String ←
    match json.getObjVal? "sameModuleDependencies" with
    | .error _ => pure #[]
    | .ok arrJ => do
        let arr ← arrJ.getArr?
        let mut acc : Array String := #[]
        for d in arr do
          let s ← d.getStr?
          acc := acc.push s
        pure acc
  return {
    declarationName, module, startLine, startColumn, endLine, endColumn
    sameModuleDependencies := depNames
    kind
  }

def buildExtractor (root : System.FilePath) (entries : Array EvalProblemMetadata) :
    IO Unit := do
  let modules := uniqueModules entries
  let _ ← runCmdCheckedCaptured "lake"
    (#["build"] ++ modules ++ #["extract_theorem"]) root
    "Failed to build Lean theorem extractor"
  pure ()

def extractOne (root : System.FilePath) (entry : EvalProblemMetadata) (hole : String) :
    IO ExtractedTheorem := do
  let binPath := root / ".lake" / "build" / "bin" / "extract_theorem"
  let out ← runCmdCheckedCaptured "lake"
    #["env", binPath.toString, entry.moduleName, hole] root
    s!"Lean extraction failed for '{entry.id}' hole '{hole}'"
  match parseExtractedTheorem out.stdout with
  | .ok e => pure e
  | .error err =>
      throw <| IO.userError
        s!"Lean extractor returned invalid JSON for '{entry.id}' hole '{hole}': {err}"

/-! ## Source paths -/

def moduleSourcePath (root : System.FilePath) (moduleName : String) : System.FilePath := Id.run do
  let parts := moduleName.splitOn "."
  let mut path := root
  for p in parts do
    path := path / p
  return path.addExtension "lean"

def ileanPath (root : System.FilePath) (moduleName : String) : System.FilePath := Id.run do
  let parts := moduleName.splitOn "."
  let mut path := root / ".lake" / "build" / "lib" / "lean"
  for p in parts do
    path := path / p
  return path.addExtension "ilean"

/-! ## Source-as-Array-Char utilities

Source-text manipulation works on `Array Char` so we can use `Nat` indices
directly. This matches Python's codepoint-indexed string semantics, which the
upstream `scripts/generate_projects.py` relies on (e.g. when applying offsets
from `.ilean`, which records codepoint columns). -/

abbrev Source := Array Char

def Source.ofString (s : String) : Source := s.toList.toArray

def Source.toString (s : Source) : String := String.mk s.toList

def Source.size (s : Source) : Nat := Array.size s

/-- Slice `s[start:end]` as a String. -/
def Source.slice (s : Source) (start endIdx : Nat) : String :=
  let endIdx := min endIdx s.size
  let start := min start endIdx
  String.mk (s.toList.drop start |>.take (endIdx - start))

/-- Convert (1-indexed line, 0-indexed codepoint column) into a codepoint
index in `s`. Mirrors `offset_for_line_column` in
`scripts/generate_projects.py`. -/
def Source.offsetForLineColumn (s : Source) (line col : Nat) : IO Nat := do
  if line < 1 then
    throw <| IO.userError s!"Invalid source line {line}"
  let mut currentLine : Nat := 1
  let mut idx : Nat := 0
  let n := s.size
  while currentLine < line do
    -- find next '\n'
    let mut found := false
    while idx < n do
      if s[idx]! == '\n' then
        idx := idx + 1
        found := true
        break
      idx := idx + 1
    if !found then
      throw <| IO.userError s!"Source ended before line {line}"
    currentLine := currentLine + 1
  return idx + col

/-- Find the first occurrence of `needle` (a `List Char`) in `s` starting at
`start`, returning the codepoint index where the match starts. -/
def Source.find (s : Source) (start : Nat) (needle : List Char) : Option Nat := Id.run do
  let n := s.size
  let m := needle.length
  if m == 0 then return some start
  let mut i := start
  while i + m ≤ n do
    let mut j := 0
    let mut matched := true
    for c in needle do
      if s[i + j]! != c then
        matched := false
        break
      j := j + 1
    if matched then return some i
    i := i + 1
  return none

/-- Find the LAST occurrence of `needle` in `s` strictly before `endIdx`. -/
def Source.rfind (s : Source) (endIdx : Nat) (needle : List Char) : Option Nat := Id.run do
  let n := min endIdx s.size
  let m := needle.length
  if m == 0 then return some n
  if m > n then return none
  let mut i : Nat := n - m + 1
  while i > 0 do
    let pos := i - 1
    let mut j := 0
    let mut matched := true
    for c in needle do
      if s[pos + j]! != c then
        matched := false
        break
      j := j + 1
    if matched then return some pos
    i := i - 1
  return none

/-- True if `s[i:]` starts with `needle`. -/
def Source.startsWithAt (s : Source) (i : Nat) (needle : List Char) : Bool := Id.run do
  let n := s.size
  let m := needle.length
  if i + m > n then return false
  let mut j := 0
  for c in needle do
    if s[i + j]! != c then return false
    j := j + 1
  return true

/-! ## Text utilities (line-based) -/

/-- Number of codepoints at the top of `source` taken up by `import` lines and
blank lines. Mirrors `import_prelude_length`. -/
def importPreludeLength (source : Source) : Nat := Id.run do
  let n := source.size
  let mut i : Nat := 0
  let mut consumed : Nat := 0
  while i < n do
    -- find end of current line
    let lineStart := i
    while i < n && source[i]! != '\n' do
      i := i + 1
    -- includes trailing '\n' if present
    let lineEnd := i
    let inclEnd := if i < n then i + 1 else i
    -- compute stripped: skip leading/trailing whitespace
    let mut s := lineStart
    while s < lineEnd && source[s]!.isWhitespace do
      s := s + 1
    let mut e := lineEnd
    while e > s && source[e - 1]!.isWhitespace do
      e := e - 1
    if s == e then
      -- blank line
      consumed := inclEnd
      i := inclEnd
    else
      -- check if starts with "import "
      let importChars := "import ".toList
      let isImport := Source.startsWithAt source s importChars
      if isImport then
        consumed := inclEnd
        i := inclEnd
      else
        return consumed
  return consumed

/-- True if the line's trimmed content is `import EvalTools.Markers`, allowing
arbitrary intra-line whitespace between `import` and the module name (the
Python regex was `\s+`, not a single space). -/
private def isEvalToolsMarkersImport (stripped : String) : Bool := Id.run do
  if !(stripped.startsWith "import") then return false
  let after := (stripped.drop "import".length).toString
  if after.isEmpty then return false
  if !after.toList.head!.isWhitespace then return false
  return after.trimAscii.toString == "EvalTools.Markers"

/-- Strip `@[eval_problem]` attribute lines and `import EvalTools.Markers`
lines from `source`. Blank lines immediately before and after a stripped
line are also dropped — mirroring the greedy `\s*` runs that bracket the
attribute in Python's `_strip_problem_markers` regex. -/
def stripProblemMarkers (source : String) : String := Id.run do
  let lines := source.splitOn "\n"
  let mut out : Array String := #[]
  let mut eatBlanks := false
  for line in lines do
    let stripped := line.trimAscii.toString
    if stripped == "@[eval_problem]" || isEvalToolsMarkersImport stripped then
      -- Drop blank lines we already pushed that immediately precede this
      -- marker line; the Python regex's leading `^\s*` consumes them too.
      while out.size > 0 && out[out.size - 1]!.trimAscii.toString.isEmpty do
        out := out.pop
      eatBlanks := true
      continue
    if eatBlanks && stripped.isEmpty then continue
    eatBlanks := false
    out := out.push line
  return "\n".intercalate out.toList

/-- Find the offset (codepoint index) of the first top-level `end ...` line at
or after `start`. Returns `source.size` if none found. Mirrors
`find_top_level_end_offset`. -/
def findTopLevelEndOffset (source : Source) (start : Nat) : Nat := Id.run do
  let n := source.size
  let mut i := start
  while i < n do
    -- start of a line. Check if line (verbatim, no leading whitespace) matches
    -- `end` optionally followed by `\s+<token>` and then end-of-line.
    let lineStart := i
    -- find end of line
    let mut j := i
    while j < n && source[j]! != '\n' do
      j := j + 1
    let lineEnd := j
    -- right-trim
    let mut k := lineEnd
    while k > lineStart && source[k - 1]!.isWhitespace do
      k := k - 1
    -- match `end` exactly or `end <something>`
    let endChars := "end".toList
    let isEnd : Bool := Id.run do
      if !(Source.startsWithAt source lineStart endChars) then return false
      let afterEnd := lineStart + 3
      if afterEnd == k then return true
      if afterEnd < k && (source[afterEnd]! == ' ' || source[afterEnd]! == '\t') then
        -- there must be some non-whitespace token before k
        let mut p := afterEnd
        while p < k && source[p]!.isWhitespace do
          p := p + 1
        return p < k
      return false
    if isEnd then return lineStart
    -- next line
    if j < n then i := j + 1 else i := j
  return n

/-! ## Source imports -/

def sourceImports (source : String) : Array String := Id.run do
  let mut out : Array String := #[]
  for line in source.splitOn "\n" do
    let stripped := line.trimAscii.toString
    if stripped.startsWith "import " then
      let rest := (stripped.drop "import ".length).trimAscii.toString
      let modName := ((rest.splitOn " ").head!).trimAscii.toString
      if !modName.isEmpty then
        out := out.push modName
  return out

partial def repoLocalImportModulesAux (root : System.FilePath) (moduleName : String)
    (seen : IO.Ref (Std.HashSet String)) : IO (Array String) := do
  let path := moduleSourcePath root moduleName
  if !(← path.pathExists) then return #[]
  let source ← IO.FS.readFile path
  let mut out : Array String := #[]
  for imported in sourceImports source do
    if imported.startsWith "Mathlib." || imported == "Mathlib" then continue
    if imported.startsWith "EvalTools." then continue
    if imported == moduleName then continue
    if (← seen.get).contains imported then continue
    let importedPath := moduleSourcePath root imported
    if !(← importedPath.pathExists) then continue
    seen.modify (·.insert imported)
    let nested ← repoLocalImportModulesAux root imported seen
    out := out ++ nested
    out := out.push imported
  return out

def repoLocalImportModules (root : System.FilePath) (moduleName : String) :
    IO (Array String) := do
  let seen ← IO.mkRef ({} : Std.HashSet String)
  repoLocalImportModulesAux root moduleName seen

/-! ## ILean metadata -/

structure IleanDeclEntry where
  name : String
  startLine : Nat
  startColumn : Nat
  deriving Inhabited

def loadIleanDeclRanges (root : System.FilePath) (moduleName : String) :
    IO (Array IleanDeclEntry) := do
  let path := ileanPath root moduleName
  if !(← path.pathExists) then
    throw <| IO.userError
      s!"Compiled metadata for module '{moduleName}' not found: {path}"
  let contents ← IO.FS.readFile path
  let json ← match Json.parse contents with
    | .ok j => pure j
    | .error err =>
        throw <| IO.userError
          s!"Invalid JSON in compiled metadata for module '{moduleName}': {err}"
  let decls ← match json.getObjVal? "decls" with
    | .ok d => pure d
    | .error _ => return #[]
  let obj ← match decls.getObj? with
    | .ok o => pure o
    | .error _ => return #[]
  let mut out : Array IleanDeclEntry := #[]
  for ⟨name, value⟩ in obj.toArray do
    match value.getArr? with
    | .error _ => continue
    | .ok arr =>
        if arr.size < 4 then continue
        match arr[0]!.getNat?, arr[1]!.getNat? with
        | .ok line, .ok col =>
            out := out.push { name, startLine := line + 1, startColumn := col }
        | _, _ => continue
  return out

/-! ## Header scanning, namespace ops -/

/-- Return `(insertAfterImports, bodyStart)` line indices for the lines in
`lines` (already split keeping their trailing newlines). Mirrors `_scan_header`. -/
def scanHeader (lines : Array String) : Nat × Nat := Id.run do
  let mut inBlockComment := false
  let mut lastImportIdx : Int := -1
  let mut bodyStart : Nat := lines.size
  let mut found := false
  for idx in [0:lines.size] do
    if found then break
    let raw := lines[idx]!
    let stripped := raw.trimAscii.toString
    if inBlockComment then
      if (stripped.splitOn "-/").length > 1 then inBlockComment := false
      continue
    if stripped.isEmpty then continue
    if stripped.startsWith "--" then continue
    if stripped.startsWith "/-" then
      let rest := (stripped.drop 2).toString
      if !((rest.splitOn "-/").length > 1) then
        inBlockComment := true
      continue
    if stripped.startsWith "import " then
      lastImportIdx := idx
      continue
    bodyStart := idx
    found := true
  if !found then bodyStart := lines.size
  let insertAt : Nat := if lastImportIdx ≥ 0 then (lastImportIdx + 1).toNat else 0
  (insertAt, bodyStart)

/-- Split `source` into lines preserving trailing newlines (like Python's
`splitlines(keepends=True)`). -/
def splitLinesKeepEnds (source : String) : Array String := Id.run do
  let parts := source.splitOn "\n"
  let mut acc : Array String := #[]
  for i in [0:parts.length] do
    let s := parts[i]!
    if i + 1 < parts.length then
      acc := acc.push (s ++ "\n")
    else if !s.isEmpty then
      acc := acc.push s
  return acc

/-- Insert `line` (must end in `\n`) just after the last import line at the
top of `source`. Mirrors `_inject_after_imports`. -/
def injectAfterImports (source line : String) : String := Id.run do
  let lines := splitLinesKeepEnds source
  let (insertAt, _) := scanHeader lines
  let anyImport := lines.any fun l => l.trimAsciiStart.toString.startsWith "import "
  if insertAt == 0 && !anyImport then
    return "import Mathlib\n" ++ line ++ source
  let before := (lines.extract 0 insertAt).foldl (· ++ ·) ""
  let after := (lines.extract insertAt lines.size).foldl (· ++ ·) ""
  return before ++ line ++ after

/-- Top-level namespace names declared in `body`, in source order. Mirrors
`_top_level_namespaces`. -/
def topLevelNamespaces (body userNamespace : String) : Array String := Id.run do
  let mut byOrder : Array String := #[]
  let mut seen : Std.HashSet String := {}
  let mut depth : Int := 0
  for raw in body.splitOn "\n" do
    let lstripped := raw.trimAsciiStart.toString
    if lstripped.startsWith "--" then continue
    if lstripped.startsWith "namespace " then
      let rest := (lstripped.drop "namespace ".length).trimAscii.toString
      let name := ((rest.splitOn " ").head!).trimAscii.toString
      if depth == 0 && name != userNamespace && !seen.contains name then
        byOrder := byOrder.push name
        seen := seen.insert name
      depth := depth + 1
      continue
    -- `end` followed by space (or just `end`); Python uses `^end\b`
    if lstripped.startsWith "end " || lstripped == "end" then
      depth := depth - 1
      continue
  return byOrder

/-- Wrap `source`'s body in `namespace Submission ... end Submission`.
Mirrors `_wrap_body_in_submission_namespace`. -/
def wrapBodyInSubmissionNamespace (source userNamespace : String) : String := Id.run do
  let lines := splitLinesKeepEnds source
  let (_, bodyStart) := scanHeader lines
  if bodyStart ≥ lines.size then return source
  let head := (lines.extract 0 bodyStart).foldl (· ++ ·) ""
  let mut body := (lines.extract bodyStart lines.size).foldl (· ++ ·) ""
  if !body.endsWith "\n" then body := body ++ "\n"
  let opens := (topLevelNamespaces body userNamespace).foldl
    (fun acc ns => acc ++ s!"open {ns}\n") ""
  return head ++ "\nnamespace Submission\n\n" ++ opens ++ body ++ "\nend Submission\n"

/-! ## Theorem statement / binder parsing -/

def lastComponentStr (name : String) : String :=
  match (name.splitOn ".").getLast? with
  | some s => s
  | none => name

/-- Word boundary at codepoint index `i`: index is past-the-end, at position
0, or preceded by a non-word char. -/
def Source.atWordStart (s : Source) (i : Nat) : Bool :=
  i == 0 || (
    let c := s[i - 1]!
    !(c.isAlphanum || c == '_' || c == '\''))

def Source.atWordEnd (s : Source) (i : Nat) : Bool :=
  i ≥ s.size || (
    let c := s[i]!
    !(c.isAlphanum || c == '_' || c == '\''))

/-- Find the first occurrence of `theorem <name>` (with word boundaries) at or
after `start`, returning the codepoint index just past the name. Mirrors the
header regex in `extract_statement_text`. -/
def Source.findTheoremHeader (s : Source) (start : Nat) (name : String) : Option Nat := Id.run do
  let needle := s!"theorem {name}".toList
  let nameSize := name.length
  let needleLen := needle.length
  let mut i := start
  let n := s.size
  while i + needleLen ≤ n do
    if Source.startsWithAt s i needle then
      let prevOk := i == 0 || s[i - 1]!.isWhitespace
      let endPos := i + needleLen
      let afterOk := Source.atWordEnd s endPos
      let _ := nameSize  -- silence unused warning
      if prevOk && afterOk then
        return some endPos
    i := i + 1
  return none

/-- Extract the theorem statement text from a sliced declaration body.
Mirrors `extract_statement_text`. -/
def extractStatementText (problemId : String) (sourcePath : System.FilePath)
    (declarationText theoremName : String) : IO String := do
  let src := Source.ofString declarationText
  let some headerEnd := Source.findTheoremHeader src 0 theoremName
    | throw <| IO.userError
        s!"Could not recover theorem statement text for '{problemId}' from {sourcePath}"
  let some byPos := Source.rfind src src.size ":= by".toList
    | throw <| IO.userError
        s!"Could not recover theorem statement text for '{problemId}' from {sourcePath}"
  if byPos < headerEnd then
    throw <| IO.userError
      s!"Could not recover theorem statement text for '{problemId}' from {sourcePath}"
  return (Source.slice src headerEnd byPos).trimAscii.toString

/-- Parse leading binders off a theorem-statement string. Returns pairs of
`(opener, body)` for each leading `(...)`, `{...}`, or `[...]` group. -/
def leadingBinders (statement : String) : Array (Char × String) := Id.run do
  let s := Source.ofString statement
  let n := s.size
  let mut binders : Array (Char × String) := #[]
  let mut i : Nat := 0
  let mut done := false
  while i < n && !done do
    while i < n && s[i]!.isWhitespace do
      i := i + 1
    if i ≥ n then break
    let opener := s[i]!
    let closer? : Option Char :=
      match opener with
      | '(' => some ')'
      | '{' => some '}'
      | '[' => some ']'
      | _ => none
    match closer? with
    | none => done := true
    | some closer =>
        let start := i
        let mut depth : Nat := 0
        let mut closed := false
        let mut j := i
        while j < n do
          let ch := s[j]!
          if ch == opener then
            depth := depth + 1
          else if ch == closer then
            depth := depth - 1
            if depth == 0 then
              let body := (Source.slice s (start + 1) j).trimAscii.toString
              binders := binders.push (opener, body)
              j := j + 1
              closed := true
              break
          j := j + 1
        i := j
        if !closed then done := true
  return binders

/-- Split `s` into whitespace-delimited tokens (empty tokens dropped). -/
private def splitWhitespace (s : String) : Array String := Id.run do
  let mut out : Array String := #[]
  let mut current : String := ""
  for c in s.toList do
    if c.isWhitespace then
      if !current.isEmpty then
        out := out.push current
        current := ""
    else
      current := current.push c
  if !current.isEmpty then
    out := out.push current
  return out

def explicitBinderApplicationArgs (statement : String) : Array String := Id.run do
  let mut args : Array String := #[]
  for (opener, body) in leadingBinders statement do
    if opener != '(' then continue
    let parts := body.splitOn ":"
    if parts.length < 2 then continue
    for name in splitWhitespace parts[0]! do
      args := args.push name
  return args

/-- Strip the `:= <body>` off the end of a sliced declaration. Mirrors
`_hole_decl_signature`. -/
def holeDeclSignature (declText basename : String) : IO String := do
  let stripped := (stripProblemMarkers declText).trimAscii.toString
  let src := Source.ofString stripped
  let some idx := Source.rfind src src.size ":=".toList
    | throw <| IO.userError
        s!"Hole '{basename}' declaration has no `:=` to split: {stripped.quote}"
  let prefix' := (Source.slice src 0 idx).trimAsciiEnd.toString
  return prefix' ++ " := "

/-- Find `<keyword> <basename>` for any keyword in `keywords`, with word
boundaries. Returns the codepoint position of the start of the keyword and
the position just past the basename. -/
def Source.findKeywordBasename (s : Source) (keywords : Array String) (basename : String) :
    Option (Nat × Nat) := Id.run do
  let n := s.size
  let basenameLen := basename.length
  let basenameChars := basename.toList
  let mut i : Nat := 0
  while i < n do
    if Source.atWordStart s i then
      for kw in keywords do
        let kwChars := kw.toList
        let kwLen := kw.length
        if Source.startsWithAt s i kwChars then
          let afterKw := i + kwLen
          if afterKw < n && s[afterKw]!.isWhitespace then
            -- consume whitespace
            let mut j := afterKw
            while j < n && s[j]!.isWhitespace do
              j := j + 1
            if Source.startsWithAt s j basenameChars then
              let endBase := j + basenameLen
              if Source.atWordEnd s endBase then
                return some (i, endBase)
    i := i + 1
  return none

/-! ## Context opens -/

def extractContextOpens (problemId : String) (sourcePath : System.FilePath)
    (source : String) (extracted? : Option ExtractedTheorem)
    (includeNamespaces : Bool) : IO String := do
  let _ := problemId
  let _ := sourcePath
  let lines := source.splitOn "\n"
  let targetLine? : Option Nat := extracted?.map fun e => e.startLine
  let mut namespaceStack : Array String := #[]
  let mut openLayers : Array (Array String) := #[#[]]
  let mut inBody := false
  let mut done := false
  for idx in [1:lines.length + 1] do
    if done then break
    if let some t := targetLine? then
      if idx ≥ t then break
    let line := lines[idx - 1]!
    let stripped := line.trimAscii.toString
    if !inBody then
      if stripped.startsWith "import " || stripped.isEmpty then continue
      inBody := true
    if targetLine?.isNone then
      let declKeywords := #["theorem", "lemma", "def", "abbrev", "opaque",
        "axiom", "instance", "class", "structure"]
      let isDecl := Id.run do
        if stripped.startsWith "@[" then return true
        for kw in declKeywords do
          if stripped.startsWith kw then
            let after := (stripped.drop kw.length).toString
            if after.isEmpty then return true
            -- check next char is non-word
            let c := after.toList.head!
            if !(c.isAlphanum || c == '_' || c == '\'') then return true
        return false
      if isDecl then
        done := true
        continue
    if stripped.startsWith "namespace " then
      let rest := (stripped.drop "namespace ".length).trimAscii.toString
      let name := ((rest.splitOn " ").head!).trimAscii.toString
      namespaceStack := namespaceStack.push name
      openLayers := openLayers.push #[]
    else if stripped.startsWith "end " || stripped == "end" then
      if namespaceStack.size > 0 then
        namespaceStack := namespaceStack.pop
        openLayers := openLayers.pop
    else if stripped.startsWith "open " then
      let layerIdx := openLayers.size - 1
      let layer := openLayers[layerIdx]!.push line
      openLayers := openLayers.set! layerIdx layer
  let mut contextLines : Array String := #[]
  for layer in openLayers do
    for ln in layer do
      contextLines := contextLines.push ln
  if includeNamespaces && namespaceStack.size > 0 then
    let nsLine := "open " ++ ".".intercalate namespaceStack.toList
    contextLines := #[nsLine] ++ contextLines
  if contextLines.isEmpty then return ""
  return "\n".intercalate contextLines.toList ++ "\n\n"

/-! ## Render ChallengeDeps.lean -/

def renderChallengeDeps (root : System.FilePath) (entry : EvalProblemMetadata)
    (extracted : ExtractedTheorem) (localImports : Array String) :
    IO (Option String) := do
  let sourcePath := moduleSourcePath root entry.moduleName
  if !(← sourcePath.pathExists) then
    throw <| IO.userError
      s!"Source file for module '{entry.moduleName}' not found: {sourcePath}"
  let sourceText ← IO.FS.readFile sourcePath
  let mut parts : Array String := #[]
  for imported in localImports do
    let importedPath := moduleSourcePath root imported
    let importedText ← IO.FS.readFile importedPath
    let importedSrc := Source.ofString importedText
    let prelude := importPreludeLength importedSrc
    let afterPrelude := Source.slice importedSrc prelude importedSrc.size
    let body := (stripProblemMarkers afterPrelude).trimAsciiStart.toString
    let body := if !body.isEmpty && !body.endsWith "\n" then body ++ "\n" else body
    if !body.isEmpty then
      parts := parts.push body
  let keepDeclarations : Std.HashSet String :=
    extracted.sameModuleDependencies.foldl (·.insert ·) {}
  if !keepDeclarations.isEmpty then
    let sourceSrc := Source.ofString sourceText
    let bodyStart := importPreludeLength sourceSrc
    let declRanges ← loadIleanDeclRanges root entry.moduleName
    let mut declStartsRaw : Array (String × Nat) := #[]
    for ileanEntry in declRanges do
      let off ← sourceSrc.offsetForLineColumn ileanEntry.startLine ileanEntry.startColumn
      declStartsRaw := declStartsRaw.push (ileanEntry.name, off)
    let declStarts := declStartsRaw.qsort (fun a b => a.2 < b.2)
    let theoremStart ← sourceSrc.offsetForLineColumn extracted.startLine extracted.startColumn
    let theoremEnd ← sourceSrc.offsetForLineColumn extracted.endLine extracted.endColumn
    let mut removeRangesRaw : Array (Nat × Nat) := #[]
    for i in [0:declStarts.size] do
      let (declName, declStart) := declStarts[i]!
      if keepDeclarations.contains declName then continue
      if declName == extracted.declarationName then
        removeRangesRaw := removeRangesRaw.push (theoremStart, theoremEnd)
        continue
      let nextStart :=
        if i + 1 < declStarts.size then declStarts[i+1]!.2
        else findTopLevelEndOffset sourceSrc declStart
      removeRangesRaw := removeRangesRaw.push (declStart, nextStart)
    let removeRanges := removeRangesRaw.qsort
      (fun a b => a.1 < b.1 || (a.1 == b.1 && a.2 < b.2))
    let mut pieces : Array String := #[]
    let mut cursor := bodyStart
    for (s, e) in removeRanges do
      if e ≤ bodyStart then continue
      let s := if s < bodyStart then bodyStart else s
      if s < cursor then continue
      pieces := pieces.push (Source.slice sourceSrc cursor s)
      cursor := e
    pieces := pieces.push (Source.slice sourceSrc cursor sourceSrc.size)
    let challengeDepsBody := (pieces.foldl (· ++ ·) "").trimAsciiStart.toString
    let challengeDepsBody :=
      if !challengeDepsBody.isEmpty && !challengeDepsBody.endsWith "\n" then
        challengeDepsBody ++ "\n"
      else challengeDepsBody
    if !challengeDepsBody.isEmpty then
      parts := parts.push challengeDepsBody
  if parts.isEmpty then return none
  let joined := "\n".intercalate (parts.toList.map (·.trimAsciiEnd.toString))
  return some ("import Mathlib\n\n" ++ joined ++ "\n")

/-! ## Python-compatible JSON pretty-printer

`Lean.Json` stores objects in an `RBNode`, which reorders keys
alphabetically/by-tree-shape and disagrees with the insertion order Python's
`json.dumps` uses. To keep `generated/` JSON files reproducible across the
two implementations we build them via an ordered-pair representation and
pretty-print with our own routine. -/

/-- A JSON value that preserves object-key insertion order. -/
inductive OJson where
  | null : OJson
  | bool : Bool → OJson
  | num : Int → OJson
  | str : String → OJson
  | arr : Array OJson → OJson
  | obj : Array (String × OJson) → OJson
  deriving Inhabited

private def hexNat4 (n : Nat) : String :=
  let digits := "0123456789abcdef"
  let nib (k : Nat) : Char := digits.get ⟨k⟩
  String.mk [nib ((n >>> 12) &&& 0xF), nib ((n >>> 8) &&& 0xF),
             nib ((n >>> 4) &&& 0xF), nib (n &&& 0xF)]

/-- Escape a string the way Python's `json.dumps(...)` does with default
`ensure_ascii=True`: ASCII printables stay literal; controls and any
codepoint above U+007F become `\uXXXX` escapes, with codepoints above the BMP
encoded as a UTF-16 surrogate pair. -/
private def escapeJsonString (s : String) : String := Id.run do
  let mut out := ""
  for c in s.toList do
    match c with
    | '"' => out := out ++ "\\\""
    | '\\' => out := out ++ "\\\\"
    | '\n' => out := out ++ "\\n"
    | '\r' => out := out ++ "\\r"
    | '\t' => out := out ++ "\\t"
    | '\x08' => out := out ++ "\\b"
    | '\x0c' => out := out ++ "\\f"
    | _ =>
        let cp := c.toNat
        if cp < 0x20 then
          out := out ++ "\\u" ++ hexNat4 cp
        else if cp < 0x7F then
          out := out.push c
        else if cp ≤ 0xFFFF then
          out := out ++ "\\u" ++ hexNat4 cp
        else
          -- UTF-16 surrogate pair
          let adj := cp - 0x10000
          let hi := 0xD800 + (adj >>> 10)
          let lo := 0xDC00 + (adj &&& 0x3FF)
          out := out ++ "\\u" ++ hexNat4 hi ++ "\\u" ++ hexNat4 lo
  return out

/-- Pretty-print `OJson` matching Python's `json.dumps(value, indent=2)`. -/
partial def OJson.pretty (j : OJson) (indent : Nat := 0) : String :=
  match j with
  | .null => "null"
  | .bool b => if b then "true" else "false"
  | .num n => toString n
  | .str s => "\"" ++ escapeJsonString s ++ "\""
  | .arr xs =>
      if xs.isEmpty then "[]"
      else
        let pad := "".pushn ' ' (indent + 2)
        let closePad := "".pushn ' ' indent
        let parts := xs.toList.map fun x => pad ++ OJson.pretty x (indent + 2)
        "[\n" ++ ",\n".intercalate parts ++ "\n" ++ closePad ++ "]"
  | .obj kvs =>
      if kvs.isEmpty then "{}"
      else
        let pad := "".pushn ' ' (indent + 2)
        let closePad := "".pushn ' ' indent
        let parts := kvs.toList.map fun (k, v) =>
          pad ++ "\"" ++ escapeJsonString k ++ "\": " ++ OJson.pretty v (indent + 2)
        "{\n" ++ ",\n".intercalate parts ++ "\n" ++ closePad ++ "}"

/-- Convenience constructors for `OJson`. -/
def ojStr (s : String) : OJson := .str s
def ojBool (b : Bool) : OJson := .bool b
def ojNat (n : Nat) : OJson := .num (Int.ofNat n)
def ojArr (xs : Array OJson) : OJson := .arr xs
def ojObj (kvs : Array (String × OJson)) : OJson := .obj kvs
def ojStrArr (xs : Array String) : OJson := .arr (xs.map ojStr)

/-! ## Holes metadata -/

/-- Build `holes.json`'s content. Mirrors `build_holes_metadata`. -/
def buildHolesMetadata (root : System.FilePath) (entry : EvalProblemMetadata)
    (extracteds : Array ExtractedTheorem) : IO String := do
  let sourcePath := moduleSourcePath root entry.moduleName
  if !(← sourcePath.pathExists) then
    throw <| IO.userError
      s!"Source file for module '{entry.moduleName}' not found: {sourcePath}"
  let sourceText ← IO.FS.readFile sourcePath
  let src := Source.ofString sourceText
  let mut holes : Array OJson := #[]
  for e in extracteds do
    let startOff ← src.offsetForLineColumn e.startLine e.startColumn
    let endOff ← src.offsetForLineColumn e.endLine e.endColumn
    let bodyRaw := Source.slice src startOff endOff
    let body := (stripProblemMarkers bodyRaw).trim
    holes := holes.push <| ojObj #[
      ("name", ojStr e.declarationName),
      ("basename", ojStr (lastComponentStr e.declarationName)),
      ("kind", ojStr e.kind),
      ("body", ojStr body)
    ]
  let payload := ojObj #[
    ("id", ojStr entry.id),
    ("module", ojStr entry.moduleName),
    ("holes", ojArr holes)
  ]
  return OJson.pretty payload ++ "\n"

/-! ## Rendering workspaces -/

private def renderReadmeLines (entry : EvalProblemMetadata)
    (extracteds : Array ExtractedTheorem) (multiHole : Bool) : Array String := Id.run do
  let mut lines : Array String := #[
    s!"# `{entry.id}`",
    "",
    entry.title,
    "",
    s!"- Problem ID: `{entry.id}`",
    s!"- Test Problem: {if entry.test then "yes" else "no"}",
    s!"- Submitter: {entry.submitter}"
  ]
  if multiHole then
    let holeDescs := extracteds.toList.map fun e => s!"`{e.declarationName}` ({e.kind})"
    lines := lines.push s!"- Holes ({extracteds.size}): {", ".intercalate holeDescs}"
  if let some notes := entry.notes then
    lines := lines.push s!"- Notes: {notes}"
  if let some source := entry.source then
    lines := lines.push s!"- Source: {source}"
  if let some informal := entry.informalSolution then
    lines := lines.push s!"- Informal solution: {informal}"
  let body :=
    if multiHole then
      #[
        "",
        "Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the",
        "trusted benchmark and fixed by the repository.",
        "",
        "This is a multi-hole problem: the challenge declares multiple `def`s,",
        "`instance`s, and/or `theorem`s as `sorry`. Fill all of them in",
        "`Submission.lean` (under `namespace Submission`) for comparator to accept",
        "your solution.",
        "",
        "Participants may use Mathlib freely. Any helper code not already available in",
        "Mathlib must be inlined into the submission workspace.",
        "",
        "`lake test` runs comparator for this problem. The command expects a comparator",
        "binary in `PATH`, or in the `COMPARATOR_BIN` environment variable."
      ]
    else
      #[
        "",
        "Do not modify `Challenge.lean` or `Solution.lean`. Those files are part of the",
        "trusted benchmark and fixed by the repository.",
        "",
        "Write your solution in `Submission.lean` and any additional local modules under",
        "`Submission/`.",
        "",
        "Participants may use Mathlib freely. Any helper code not already available in",
        "Mathlib must be inlined into the submission workspace.",
        "",
        "Multi-file submissions are allowed through `Submission.lean` and additional local",
        "modules under `Submission/`.",
        "",
        "`lake test` runs comparator for this problem. The command expects a comparator",
        "binary in `PATH`, or in the `COMPARATOR_BIN` environment variable."
      ]
  return lines ++ body

private def lakefileToml (problemId : String) (mathlibDep : DependencySpec)
    (withChallengeDeps : Bool) : String :=
  let challengeDepsLib :=
    if withChallengeDeps then
      "[[lean_lib]]\nname = \"ChallengeDeps\"\n\n"
    else ""
  s!"name = \"{problemId}\"\n" ++
  "testDriver = \"workspace_test\"\n" ++
  "defaultTargets = [\"Challenge\", \"Solution\", \"Submission\"]\n\n" ++
  "[leanOptions]\n" ++
  "autoImplicit = false\n\n" ++
  "[[require]]\n" ++
  s!"name = \"{mathlibDep.name}\"\n" ++
  s!"git = \"{mathlibDep.git}\"\n" ++
  s!"rev = \"{mathlibDep.rev}\"\n\n" ++
  challengeDepsLib ++
  "[[lean_lib]]\nname = \"Challenge\"\n\n" ++
  "[[lean_lib]]\nname = \"Solution\"\n\n" ++
  "[[lean_lib]]\nname = \"Submission\"\n\n" ++
  "[[lean_exe]]\nname = \"workspace_test\"\nroot = \"WorkspaceTest\"\n"

/-! ## Multi-hole rendering -/

private def renderWorkspaceMultiHole (root : System.FilePath) (entry : EvalProblemMetadata)
    (extracteds : Array ExtractedTheorem) (toolchain : String)
    (mathlibDep : DependencySpec) (workspaceTest : String) :
    IO (Array (String × String)) := do
  let sourcePath := moduleSourcePath root entry.moduleName
  if !(← sourcePath.pathExists) then
    throw <| IO.userError
      s!"Source file for module '{entry.moduleName}' not found: {sourcePath}"
  let sourceText ← IO.FS.readFile sourcePath
  let src := Source.ofString sourceText
  -- compute (start, end, fullName, kind) for each hole, sorted by start
  let mut holesRaw : Array (Nat × Nat × String × String) := #[]
  for e in extracteds do
    let s ← src.offsetForLineColumn e.startLine e.startColumn
    let eo ← src.offsetForLineColumn e.endLine e.endColumn
    holesRaw := holesRaw.push (s, eo, e.declarationName, e.kind)
  let holesWithRanges := holesRaw.qsort (fun a b => a.1 < b.1)
  -- theorem vs definition names
  let mut theoremNames : Array String := #[]
  let mut definitionNames : Array String := #[]
  for (_, _, name, kind) in holesWithRanges do
    if kind == "theorem" then theoremNames := theoremNames.push name
    else definitionNames := definitionNames.push name
  -- Challenge body: source verbatim minus markers; ensure `import Mathlib` present
  let challengeBodyStripped := stripProblemMarkers sourceText
  let challengeBody :=
    if !(challengeBodyStripped.trimAsciiStart.toString.startsWith "import ") then
      "import Mathlib\n\n" ++ challengeBodyStripped
    else challengeBodyStripped
  -- Solution body: replace each hole's body with delegation to Submission.<name>
  let mut solutionText := sourceText
  -- iterate holes in reverse order so earlier offsets stay valid
  let mut i : Int := holesWithRanges.size - 1
  while i ≥ 0 do
    let (startOff, endOff, fullName, kind) := holesWithRanges[i.toNat]!
    let declText := Source.slice src startOff endOff
    let basename := lastComponentStr fullName
    let mut signature ← holeDeclSignature declText basename
    if kind != "theorem" then
      match Source.findKeywordBasename (Source.ofString signature) #["def", "instance", "abbrev"] basename with
      | none =>
          throw <| IO.userError
            s!"Could not anchor `@[reducible]` injection in signature for hole '{fullName}'."
      | some (kwStart, _) =>
          let sigSrc := Source.ofString signature
          signature := (Source.slice sigSrc 0 kwStart) ++ "@[reducible] "
            ++ (Source.slice sigSrc kwStart sigSrc.size)
    -- find decl keyword in source decl text to extract statement portion
    let declSrc := Source.ofString declText
    let some (_, kwEnd) := Source.findKeywordBasename declSrc
      #["def", "instance", "theorem", "opaque", "lemma", "abbrev", "class", "example"] basename
      | throw <| IO.userError
          s!"Could not locate basename '{basename}' in source decl for hole '{fullName}'."
    let between := Source.slice declSrc kwEnd declSrc.size
    let betweenSrc := Source.ofString between
    let some lastEq := Source.rfind betweenSrc betweenSrc.size ":=".toList
      | throw <| IO.userError s!"Source decl for hole '{fullName}' has no `:=` body marker."
    let statement := Source.slice betweenSrc 0 lastEq
    let explicitArgs := explicitBinderApplicationArgs statement
    let applied :=
      if explicitArgs.isEmpty then s!"Submission.{fullName}"
      else s!"Submission.{fullName} " ++ " ".intercalate explicitArgs.toList
    let newDecl := signature ++ applied
    let solSrc := Source.ofString solutionText
    solutionText := Source.slice solSrc 0 startOff ++ newDecl
      ++ Source.slice solSrc endOff solSrc.size
    i := i - 1
  let solutionBody := stripProblemMarkers solutionText
  let solutionBody := injectAfterImports solutionBody "import Submission\n"
  let submissionStripped := stripProblemMarkers sourceText
  let submissionWithHelpers := injectAfterImports submissionStripped "import Submission.Helpers\n"
  let userNamespace := lastComponentStr entry.moduleName
  let submissionBody := wrapBodyInSubmissionNamespace submissionWithHelpers userNamespace
  -- config
  let mut configPairs : Array (String × OJson) := #[
    ("challenge_module", ojStr "Challenge"),
    ("solution_module", ojStr "Solution"),
    ("theorem_names", ojStrArr theoremNames),
    ("permitted_axioms", ojStrArr fixedAxioms),
    ("enable_nanoda", ojBool false)
  ]
  if !definitionNames.isEmpty then
    configPairs := configPairs.push ("definition_names", ojStrArr definitionNames)
  let config := ojObj configPairs
  let toolchain' := if toolchain.endsWith "\n" then toolchain else toolchain ++ "\n"
  let challenge :=
    if challengeBody.endsWith "\n" then challengeBody else challengeBody ++ "\n"
  let readmeLines := renderReadmeLines entry extracteds (multiHole := true)
  let readme := "\n".intercalate readmeLines.toList ++ "\n"
  return #[
    ("README.md", readme),
    ("lean-toolchain", toolchain'),
    ("lakefile.toml", lakefileToml entry.id mathlibDep (withChallengeDeps := false)),
    ("Challenge.lean", challenge),
    ("Solution.lean", solutionBody),
    ("Submission.lean", submissionBody),
    ("Submission/Helpers.lean", "namespace Submission.Helpers\n\nend Submission.Helpers\n"),
    ("WorkspaceTest.lean", workspaceTest),
    ("config.json", OJson.pretty config ++ "\n")
  ]

/-! ## Single-hole rendering -/

private def renderWorkspaceSingleHole (root : System.FilePath) (entry : EvalProblemMetadata)
    (extracted : ExtractedTheorem) (toolchain : String) (mathlibDep : DependencySpec)
    (workspaceTest : String) : IO (Array (String × String)) := do
  let sourcePath := moduleSourcePath root entry.moduleName
  let sourceText ← IO.FS.readFile sourcePath
  let src := Source.ofString sourceText
  let theoremName := lastComponentStr extracted.declarationName
  let startOff ← src.offsetForLineColumn extracted.startLine extracted.startColumn
  let endOff ← src.offsetForLineColumn extracted.endLine extracted.endColumn
  let declText := Source.slice src startOff endOff
  let theoremStatement ← extractStatementText entry.id sourcePath declText theoremName
  let solutionArgs := explicitBinderApplicationArgs theoremStatement
  let solutionExact :=
    if solutionArgs.isEmpty then s!"Submission.{theoremName}"
    else s!"Submission.{theoremName} " ++ " ".intercalate solutionArgs.toList
  let localImports ← repoLocalImportModules root entry.moduleName
  let challengeDeps? ← renderChallengeDeps root entry extracted localImports
  let hasChallengeDeps := challengeDeps?.isSome
  let challengeImport :=
    if hasChallengeDeps then "import ChallengeDeps\n\n" else "import Mathlib\n\n"
  let solutionImports :=
    if hasChallengeDeps then "import ChallengeDeps\nimport Submission\n\n"
    else "import Mathlib\nimport Submission\n\n"
  let submissionImports :=
    if hasChallengeDeps then "import ChallengeDeps\nimport Submission.Helpers\n\n"
    else "import Mathlib\nimport Submission.Helpers\n\n"
  let includeNamespaces := hasChallengeDeps || !localImports.isEmpty
  let contextOpenBlock ←
    extractContextOpens entry.id sourcePath sourceText (some extracted) includeNamespaces
  let contextOpenBlock :=
    if !contextOpenBlock.isEmpty && !contextOpenBlock.endsWith "\n\n" then
      contextOpenBlock ++ "\n"
    else contextOpenBlock
  let toolchain' := if toolchain.endsWith "\n" then toolchain else toolchain ++ "\n"
  let config := ojObj #[
    ("challenge_module", ojStr "Challenge"),
    ("solution_module", ojStr "Solution"),
    ("theorem_names", ojArr #[ojStr theoremName]),
    ("permitted_axioms", ojStrArr fixedAxioms),
    ("enable_nanoda", ojBool false)
  ]
  let readmeLines := renderReadmeLines entry #[extracted] (multiHole := false)
  let readme := "\n".intercalate readmeLines.toList ++ "\n"
  let challengeFile :=
    challengeImport ++ contextOpenBlock ++
    s!"theorem {theoremName} {theoremStatement} := by\n  sorry\n"
  let solutionFile :=
    solutionImports ++ contextOpenBlock ++
    s!"theorem {theoremName} {theoremStatement} := by\n  exact {solutionExact}\n"
  let submissionFile :=
    submissionImports ++ contextOpenBlock ++
    "namespace Submission\n\n" ++
    s!"theorem {theoremName} {theoremStatement} := by\n  sorry\n\n" ++
    "end Submission\n"
  let mut files : Array (String × String) := #[
    ("README.md", readme),
    ("lean-toolchain", toolchain'),
    ("lakefile.toml", lakefileToml entry.id mathlibDep (withChallengeDeps := hasChallengeDeps)),
    ("Challenge.lean", challengeFile),
    ("Solution.lean", solutionFile),
    ("Submission.lean", submissionFile),
    ("Submission/Helpers.lean", "namespace Submission.Helpers\n\nend Submission.Helpers\n"),
    ("WorkspaceTest.lean", workspaceTest),
    ("config.json", OJson.pretty config ++ "\n")
  ]
  if let some cd := challengeDeps? then
    files := files.push ("ChallengeDeps.lean", cd)
  return files

/-- Render every file in a generated workspace. Mirrors `render_workspace`. -/
def renderWorkspace (root : System.FilePath) (entry : EvalProblemMetadata)
    (extracteds : Array ExtractedTheorem) (toolchain : String)
    (mathlibDep : DependencySpec) (workspaceTest : String) :
    IO (Array (String × String)) := do
  let isMultiHole :=
    extracteds.size != 1 || extracteds[0]!.kind != "theorem"
  let baseFiles ←
    if isMultiHole then
      renderWorkspaceMultiHole root entry extracteds toolchain mathlibDep workspaceTest
    else
      renderWorkspaceSingleHole root entry extracteds[0]! toolchain mathlibDep workspaceTest
  let holesJson ← buildHolesMetadata root entry extracteds
  return baseFiles.push ("holes.json", holesJson)

/-! ## Workspace I/O -/

/-- All files under `dir` (recursively), as paths relative to `dir`, posix
style (forward slashes). Skips entries whose first component is in
`ignoredPathNames`. Mirrors `gather_extra_paths`'s `extras` computation. -/
partial def listFilesRecursive (dir : System.FilePath) : IO (Array System.FilePath) := do
  if !(← dir.isDir) then return #[]
  let mut out : Array System.FilePath := #[]
  for entry in (← dir.readDir) do
    if (← entry.path.isDir) then
      let nested ← listFilesRecursive entry.path
      for n in nested do
        out := out.push (entry.fileName / n)
    else
      out := out.push entry.fileName
  return out

/-- Returns the list of paths (relative to `problemDir`) that are present in
the directory but not part of `expectedFiles`, sorted. -/
def gatherExtraPaths (problemDir : System.FilePath) : IO (Array System.FilePath) := do
  if !(← problemDir.pathExists) then return #[]
  let all ← listFilesRecursive problemDir
  let all := all.qsort (fun a b => a.toString < b.toString)
  let expected : Std.HashSet String := expectedFiles.foldl (·.insert ·) {}
  let mut out : Array System.FilePath := #[]
  for p in all do
    let posix := "/".intercalate (p.components.map id)
    let firstComp := p.components.head!
    if ignoredPathNames.contains firstComp then continue
    if expected.contains posix then continue
    out := out.push p
  return out

/-- Write the rendered files into `problemDir`, replacing any stale content.
Mirrors `write_workspace`. -/
def writeWorkspace (problemDir : System.FilePath)
    (files : Array (String × String)) : IO Unit := do
  IO.FS.createDirAll problemDir
  let provided : Std.HashSet String := files.foldl (fun acc (p, _) => acc.insert p) {}
  for relPath in expectedFiles do
    if provided.contains relPath then continue
    let dest := problemDir / relPath
    if (← dest.pathExists) then
      let info ← dest.metadata
      if info.type == .file then
        IO.FS.removeFile dest
  for extra in (← gatherExtraPaths problemDir) do
    IO.FS.removeFile (problemDir / extra)
  for (relPath, content) in files do
    let dest := problemDir / relPath
    if let some parent := dest.parent then
      IO.FS.createDirAll parent
    IO.FS.writeFile dest content

/-- Return a list of mismatches between expected files and what's on disk.
Mirrors `check_workspace`. -/
def checkWorkspace (problemDir : System.FilePath) (relToRoot : String)
    (files : Array (String × String)) : IO (Array String) := do
  let mut mismatches : Array String := #[]
  let provided : Std.HashSet String := files.foldl (fun acc (p, _) => acc.insert p) {}
  for relPath in expectedFiles do
    if provided.contains relPath then continue
    let dest := problemDir / relPath
    if (← dest.pathExists) then
      mismatches := mismatches.push s!"unexpected {relToRoot}/{relPath}"
  for (relPath, expectedContent) in files do
    let dest := problemDir / relPath
    if !(← dest.pathExists) then
      mismatches := mismatches.push s!"missing {relToRoot}/{relPath}"
      continue
    let info ← dest.metadata
    if info.type != .file then
      mismatches := mismatches.push s!"missing {relToRoot}/{relPath}"
      continue
    let actual ← IO.FS.readFile dest
    if actual != expectedContent then
      mismatches := mismatches.push s!"stale {relToRoot}/{relPath}"
  for extra in (← gatherExtraPaths problemDir) do
    let posix := "/".intercalate (extra.components.map id)
    mismatches := mismatches.push s!"unexpected {relToRoot}/{posix}"
  return mismatches

/-! ## Validate hole shape -/

/-- Sanity-check that each manifest hole appears as a top-level
`theorem/def/instance/opaque` declaration in its source module. Mirrors
`validate_hole_shape`. -/
def validateHoleShape (root : System.FilePath) (entries : Array EvalProblemMetadata) :
    IO Unit := do
  for entry in entries do
    let sourcePath := moduleSourcePath root entry.moduleName
    if !(← sourcePath.pathExists) then
      throw <| IO.userError
        s!"Source file for module '{entry.moduleName}' not found: {sourcePath}"
    let sourceText ← IO.FS.readFile sourcePath
    let src := Source.ofString sourceText
    for hole in entry.holes do
      let basename := lastComponentStr hole
      match Source.findKeywordBasename src #["theorem", "opaque", "def", "instance"] basename with
      | some _ => continue
      | none =>
          let display :=
            let sp := sourcePath.toString
            let rp := root.toString ++ "/"
            if sp.startsWith rp then sp.drop rp.length |>.toString else sp
          throw <| IO.userError
            s!"Problem '{entry.id}' lists hole '{basename}' which is not declared as a top-level theorem/def/instance in {display}."

/-! ## Sync unknown / index -/

/-- Remove (or report) workspace directories under `generated/` that aren't in
`selectedIds`. Mirrors `sync_unknown_problem_dirs`. -/
def syncUnknownProblemDirs (root : System.FilePath) (selectedIds : Std.HashSet String)
    (check : Bool) : IO (Array String) := do
  let generated := root / "generated"
  IO.FS.createDirAll generated
  let mut mismatches : Array String := #[]
  let entries ← generated.readDir
  let entries := entries.qsort (fun a b => a.fileName < b.fileName)
  for e in entries do
    if e.fileName == "index.json" then continue
    if !(← e.path.isDir) then continue
    if selectedIds.contains e.fileName then continue
    if check then
      mismatches := mismatches.push s!"unexpected generated directory generated/{e.fileName}"
    else
      IO.FS.removeDirAll e.path
  return mismatches

/-- Write or check `generated/index.json`. Mirrors `write_or_check_index`. -/
def writeOrCheckIndex (root : System.FilePath) (entries : Array OJson) (check : Bool) :
    IO (Array String) := do
  let generated := root / "generated"
  let indexPath := generated / "index.json"
  let content := OJson.pretty (ojArr entries) ++ "\n"
  if check then
    if !(← indexPath.pathExists) then
      return #["missing generated/index.json"]
    let actual ← IO.FS.readFile indexPath
    if actual != content then
      return #["stale generated/index.json"]
    return #[]
  IO.FS.createDirAll generated
  IO.FS.writeFile indexPath content
  return #[]

/-! ## Generate orchestrator -/

/-- Main `generate` entry point. Mirrors `scripts/generate_projects.py:generate`. -/
def generate (root : System.FilePath) (selectedProblemId : Option String) (check : Bool) :
    IO Unit := do
  let problems ← loadManifest root
  let selectedProblems ←
    match selectedProblemId with
    | some id =>
        let filtered := problems.filter (·.id == id)
        if filtered.isEmpty then
          throw <| IO.userError s!"Unknown problem id '{id}'"
        pure filtered
    | none =>
        validateManifestAgainstInventory root problems
        let selectedIds : Std.HashSet String :=
          problems.foldl (fun acc p => acc.insert p.id) {}
        let mismatches ← syncUnknownProblemDirs root selectedIds check
        if !mismatches.isEmpty then
          throw <| IO.userError <| "\n".intercalate mismatches.toList
        pure problems
  validateHoleShape root selectedProblems
  let toolchain ← IO.FS.readFile (root / "lean-toolchain")
  let mathlibDep ← loadRootMathlibDependency root
  buildExtractor root selectedProblems
  let workspaceTest ← loadWorkspaceTestTemplate root
  let mut indexEntries : Array OJson := #[]
  let mut mismatches : Array String := #[]
  for entry in selectedProblems do
    let mut extracteds : Array ExtractedTheorem := #[]
    for hole in entry.holes do
      let e ← extractOne root entry hole
      extracteds := extracteds.push e
    let files ← renderWorkspace root entry extracteds toolchain mathlibDep workspaceTest
    let problemDir := root / "generated" / entry.id
    let relDisplay := s!"generated/{entry.id}"
    if check then
      mismatches := mismatches ++ (← checkWorkspace problemDir relDisplay files)
    else
      writeWorkspace problemDir files
    indexEntries := indexEntries.push <| ojObj #[
      ("id", ojStr entry.id),
      ("title", ojStr entry.title),
      ("test", ojBool entry.test),
      ("submitter", ojStr entry.submitter),
      ("module", ojStr entry.moduleName),
      ("holes", ojStrArr entry.holes),
      ("generated_path", ojStr s!"generated/{entry.id}")
    ]
  if selectedProblemId.isNone then
    mismatches := mismatches ++ (← writeOrCheckIndex root indexEntries check)
  if !mismatches.isEmpty then
    throw <| IO.userError <| "\n".intercalate mismatches.toList
  if check then
    IO.println "Generated workspaces are up to date."
  else
    IO.println s!"Generated {selectedProblems.size} problem workspace(s)."

end EvalTools
