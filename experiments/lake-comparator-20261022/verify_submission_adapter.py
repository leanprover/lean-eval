"""Run the actual submissions adapter against a controlled multi-problem source."""

import argparse
import json
from pathlib import Path
import shutil
import subprocess


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("pipeline", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--benchmark", type=Path, default=Path(__file__).resolve().parents[2])
    args = parser.parse_args()
    root = args.benchmark.resolve()
    args.output.mkdir(parents=True)
    source = args.output / "source"
    source.mkdir()
    for problem in ("two_plus_two", "def_hole_example", "variable_binder_example"):
        target = source / problem
        shutil.copytree(root / "generated" / problem, target)
        submission = target / "Submission.lean"
        text = submission.read_text()
        if problem == "two_plus_two":
            text = "import LeanPool.Basic\n" + text.replace("  sorry", "  cases (show hello = \"world\" from rfl)\n  rfl")
        elif problem == "def_hole_example":
            text = text.replace("def foo : Nat := sorry", "def foo : Nat := 37")
            text = text.replace("theorem foo_def : foo = 37 := sorry", "theorem foo_def : foo = 37 := rfl")
        else:
            text = text.replace("  sorry", "  fail")
        submission.write_text(text)
    with (args.output / "adapter.log").open("w") as log:
        subprocess.run([
            "python3", str(args.pipeline / "scripts/evaluate_submission.py"),
            "--source-dir", str(source), "--generated-root", str(root / "generated"),
            "--manifest-dir", str(root / "manifests/problems"),
            "--output-dir", str(args.output / "results"), "--repo-root", str(root),
            "--shared-packages", str(root / ".lake/packages"),
        ], check=True, stdout=log, stderr=subprocess.STDOUT)
    result = json.loads((args.output / "results/results.json").read_text())
    assert sorted(result["passed"]) == ["def_hole_example", "two_plus_two"], result
    summary = json.loads((args.output / "results/summary.json").read_text())
    scores = summary["run_eval"]
    assert scores["attempted_problems"] == 3 and scores["succeeded_problems"] == 2, scores
    failed = next(p for p in scores["problems"] if p["id"] == "variable_binder_example")
    assert failed["exit_code"] == 1 and not failed["succeeded"], failed
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
