#!/usr/bin/env python3
"""Isolated migration experiments; never modifies production workspaces."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import time
import importlib.util

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TOOLCHAIN = os.environ.get("LEAN_COMPARATOR_PROBE_TOOLCHAIN", "leanprover/lean4:v4.35.0-rc3")
LEAN_BIN = Path.home() / ".elan/toolchains" / TOOLCHAIN.replace("/", "--").replace(":", "---") / "bin"
LAKE = LEAN_BIN / "lake"
BWRAP = Path(shutil.which("bwrap") or "/missing-bwrap").resolve()


def run(label: str, workspace: Path, arguments: list[str], *,
        env: dict[str, str] | None = None, expected: int | None = None,
        timeout: int = 240) -> dict:
    logs = HERE / "logs"
    logs.mkdir(exist_ok=True)
    log = logs / f"{label}.log"
    original = label
    index = 1
    while log.exists():
        index += 1
        label = f"{original}-r{index}"
        log = logs / f"{label}.log"
    environment = {**os.environ, "COMPARATOR_BWRAP": str(BWRAP)}
    environment.update(env or {})
    started = time.monotonic()
    with log.open("w") as output:
        process = subprocess.Popen(arguments, cwd=workspace, env=environment,
                                   stdout=output, stderr=subprocess.STDOUT,
                                   start_new_session=True)
        timed_out = False
        try:
            code = process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed_out = True
            os.killpg(process.pid, signal.SIGKILL)
            code = process.wait()
    result = {"label": label, "workspace": str(workspace), "argv": arguments,
              "exit_code": code, "expected_exit": expected,
              "seconds": round(time.monotonic() - started, 3),
              "timed_out": timed_out, "log": str(log.relative_to(HERE)),
              "log_sha256": hashlib.sha256(log.read_bytes()).hexdigest()}
    if expected is not None:
        result["as_expected"] = code == expected and not timed_out
    with (HERE / "results.jsonl").open("a") as output:
        output.write(json.dumps(result) + "\n")
    print(json.dumps(result), flush=True)
    if expected is not None and code != expected:
        print(log.read_text()[-3000:], flush=True)
    return result


def config(**changes: object) -> dict:
    return {"challenge_module": "Challenge", "solution_module": "Solution",
            "theorem_names": ["target"], "definition_names": [],
            "permitted_axioms": ["propext", "Quot.sound", "Classical.choice"],
            "external_kernels": {"nanoda": [str(LEAN_BIN / "nanoda_bin")]},
            **changes}


def fixture(directory: Path, *, challenge: str = "theorem target : True := by sorry\n",
            submission: str = "namespace Submission\ntheorem target : True := True.intro\nend Submission\n",
            solution: str = "import Submission\ntheorem target : True := Submission.target\n",
            settings: dict | None = None) -> Path:
    directory.mkdir(parents=True, exist_ok=True)
    files = {"lean-toolchain": TOOLCHAIN + "\n",
             "lakefile.toml": 'name = "probe"\n[leanOptions]\nautoImplicit = false\n'
                 '[[lean_lib]]\nname = "Challenge"\n[[lean_lib]]\nname = "Submission"\n'
                 '[[lean_lib]]\nname = "Solution"\n',
             "lake-manifest.json": json.dumps({"version": "1.1.0", "packagesDir": ".lake/packages",
                 "packages": [], "name": "probe", "lakeDir": ".lake"}),
             "Challenge.lean": challenge, "Submission.lean": submission,
             "Solution.lean": solution,
             "config.json": json.dumps(settings if settings is not None else config(), indent=2)}
    for name, content in files.items():
        (directory / name).write_text(content)
    return directory


def compare(label: str, workspace: Path, *, expected: int | None = None,
            env: dict[str, str] | None = None, extra: list[str] | None = None,
            timeout: int = 240) -> dict:
    return run(label, workspace, [str(LAKE), "comparator", "--config", "config.json", *(extra or [])],
               env=env, expected=expected, timeout=timeout)


def core(scratch: Path) -> None:
    compare("core-valid", fixture(scratch / "valid"), expected=0)
    compare("core-sorry", fixture(scratch / "sorry", submission=
        "namespace Submission\ntheorem target : True := by sorry\nend Submission\n"), expected=1)
    compare("core-forbidden-axiom", fixture(scratch / "axiom", submission=
        "namespace Submission\naxiom bad : True\ntheorem target : True := bad\nend Submission\n"), expected=1)
    compare("core-statement-mismatch", fixture(scratch / "mismatch", solution=
        "import Submission\ntheorem target : True ∧ True := ⟨Submission.target, Submission.target⟩\n"), expected=1)
    compare("core-definition-hole", fixture(scratch / "definition",
        challenge="def foo : Nat := sorry\ntheorem target : foo = 37 := by sorry\n",
        submission="namespace Submission\ndef foo : Nat := 37\ntheorem target : foo = 37 := rfl\nend Submission\n",
        solution="import Submission\n@[reducible] def foo : Nat := Submission.foo\n"
                 "theorem target : foo = 37 := Submission.target\n",
        settings=config(definition_names=["foo"])), expected=0)
    compare("core-dependent-holes", fixture(scratch / "dependent",
        challenge="def carrier : Type := sorry\ndef value : carrier := sorry\n"
                  "theorem target : value = value := by sorry\n",
        submission="namespace Submission\nabbrev carrier : Type := Nat\ndef value : carrier := 37\n"
                   "theorem target : value = value := rfl\nend Submission\n",
        solution="import Submission\n@[reducible] def carrier : Type := Submission.carrier\n"
                 "@[reducible] def value : carrier := Submission.value\n"
                 "theorem target : value = value := Submission.target\n",
        settings=config(definition_names=["carrier", "value"])), expected=0)
    missing = fixture(scratch / "missing-manifest")
    (missing / "lake-manifest.json").unlink()
    compare("core-missing-manifest", missing, expected=2)
    compare("core-missing-bwrap", fixture(scratch / "missing-bwrap"), expected=2,
            env={"COMPARATOR_BWRAP": "/no-such-bwrap"})
    compare("core-paranoid", fixture(scratch / "paranoid"), extra=["--paranoid"], expected=0)


CACHE = Path("/home/kim/worktrees/lean-eval-review-653/.lake/packages")


def trusted_path() -> str:
    paths = [str(LEAN_BIN)]
    for name in ["git", "env", "sh", "bash", "which", "cc", "clang", "ld", "timeout"]:
        executable = shutil.which(name)
        if executable:
            directory = str(Path(executable).resolve().parent)
            if directory not in paths:
                paths.append(directory)
    return os.pathsep.join(paths)


def cache_wrapper(scratch: Path) -> Path:
    wrapper = scratch / "bwrap-with-cache"
    wrapper.write_text("#!/run/current-system/sw/bin/python3\nimport os, sys\n"
        f"real = {str(BWRAP)!r}\ncache = {str(CACHE)!r}\n"
        "args = sys.argv[1:]\ni = args.index('--')\n"
        "os.execv(real, [real, *args[:i], '--ro-bind', cache, cache, *args[i:]])\n")
    wrapper.chmod(0o755)
    return wrapper


def generated(scratch: Path) -> None:
    wrapper = cache_wrapper(scratch)
    for problem in ["two_plus_two", "def_hole_example", "variable_binder_example"]:
        workspace = scratch / problem
        if workspace.exists():
            shutil.rmtree(workspace)
        shutil.copytree(ROOT / "generated" / problem, workspace)
        shutil.copyfile(ROOT / "lake-manifest.json", workspace / "lake-manifest.json")
        (workspace / ".lake").mkdir(exist_ok=True)
        (workspace / ".lake/packages").symlink_to(CACHE)
        path = workspace / "Submission.lean"
        content = path.read_text()
        if problem == "two_plus_two":
            content = content.replace("  sorry", "  rfl")
        elif problem == "def_hole_example":
            content = content.replace("def foo : Nat := sorry", "def foo : Nat := 37")
            content = content.replace("theorem foo_def : foo = 37 := sorry", "theorem foo_def : foo = 37 := rfl")
        else:
            content = content.replace("(hA : A.IsHermitian)", "(_hA : A.IsHermitian)")
            content = content.replace("  sorry", "  rfl")
        path.write_text(content)
        settings = json.loads((workspace / "config.json").read_text())
        settings.pop("enable_nanoda", None)
        settings["external_kernels"] = {"nanoda": [str(LEAN_BIN / "nanoda_bin")]}
        (workspace / "config.json").write_text(json.dumps(settings, indent=2))
        if problem == "two_plus_two":
            compare("generated-external-cache-unmodified", workspace, expected=1)
        compare("generated-" + problem, workspace, expected=0,
                env={"COMPARATOR_BWRAP": str(wrapper)}, timeout=600)


def mounted_cache(scratch: Path) -> None:
    workspace = scratch / "two_plus_two"
    shutil.copytree(Path("/tmp/lean-eval-lake-comparator-20261022/generated/two_plus_two"),
                    workspace, ignore=shutil.ignore_patterns(".lake"), dirs_exist_ok=True)
    (workspace / ".lake").mkdir(exist_ok=True)
    (workspace / ".lake/packages").symlink_to("/opt/lean-eval-migration-cache")
    run("generated-stock-lake-fixed-cache-mount", workspace,
        [str(BWRAP), "--ro-bind", "/", "/", "--tmpfs", "/opt",
         "--ro-bind", str(CACHE), "/opt/lean-eval-migration-cache",
         "--bind", str(workspace), str(workspace), "--dev", "/dev", "--proc", "/proc",
         "--unshare-all", "--die-with-parent", "--", str(LAKE), "comparator", "--config", "config.json"],
        env={"PATH": trusted_path()}, expected=0, timeout=600)


def security(scratch: Path) -> None:
    # Reuse the existing repository probe's exact tool-shadow payload.
    spec = importlib.util.spec_from_file_location("tool_probe", ROOT / "scripts/security_probes/tool_path_probe.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    workspace = fixture(scratch / "tool-shadow", submission=module.SUBMISSION)
    compare("security-tool-shadow-direct", workspace, expected=0, env={"PATH": trusted_path()})
    print("tool shadows:", {name: (workspace / ".lake" / name).exists()
          for name in ["tool-shadow-planted", "tool-shadow-used"]}, flush=True)
    marker = scratch / "synthetic-host-marker"
    marker.write_text("probe-only")
    submission = '''import Lean
initialize do
  IO.FS.createDirAll ".lake/probe"
  let mut lines : Array String := #[]
  for (label, path) in #[("source", "outside.lean"), ("parent", "../outside"),
                         ("cache", ".lake/allowed")] do
    try
      IO.FS.writeFile path "probe-only"
      lines := lines.push (label ++ "=allowed")
    catch _ => lines := lines.push (label ++ "=denied")
  lines := lines.push ("synthetic-env=" ++ (← IO.getEnv "MIGRATION_PROBE_SECRET").getD "absent")
  try
    let text ← IO.FS.readFile "HOST_MARKER"
    lines := lines.push ("host-marker=" ++ text)
  catch _ => lines := lines.push "host-marker=hidden"
  let routes ← IO.FS.readFile "/proc/net/route"
  lines := lines.push ("routes=" ++ routes)
  IO.FS.writeFile ".lake/probe/result.txt" ("\\n".intercalate lines.toList)
namespace Submission
theorem target : True := True.intro
end Submission
'''.replace("HOST_MARKER", str(marker))
    workspace = fixture(scratch / "confinement", submission=submission)
    compare("security-confinement", workspace, expected=0,
            env={"PATH": trusted_path(), "MIGRATION_PROBE_SECRET": "probe-only-not-a-credential"})
    observed = (workspace / ".lake/probe/result.txt").read_text()
    (HERE / "confinement-observations.txt").write_text(observed)
    print(observed, flush=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("group", choices=["core", "generated", "mounted-cache", "security"])
    parser.add_argument("--scratch", type=Path, required=True)
    args = parser.parse_args()
    args.scratch.mkdir(parents=True, exist_ok=True)
    {"core": core, "generated": generated, "mounted-cache": mounted_cache,
     "security": security}[args.group](args.scratch)


if __name__ == "__main__":
    main()
