from __future__ import annotations

import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[2]
TEMPLATES = (
    ROOT / "README.md",
    ROOT / ".github/ISSUE_TEMPLATE/config.yml",
    ROOT / ".github/ISSUE_TEMPLATE/submit.yml",
    ROOT / ".github/ISSUE_TEMPLATE/problem-report.yml",
)


class IssueTemplateTests(unittest.TestCase):
    def test_submission_redirects_are_server_only(self) -> None:
        for template in TEMPLATES:
            with self.subTest(template=template.name):
                text = " ".join(template.read_text(encoding="utf-8").lower().split())
                self.assertIn("https://lean-lang.org/eval/submit/", text)
                for retired_copy in (
                    "lean-eval-submissions/issues",
                    "issue intake",
                    "issue-intake",
                    "2026-09-02T06:57:10Z",
                    "2026-09-02T23:06:35Z",
                    "2026-09-30T06:57:10Z",
                    "fallback through",
                ):
                    self.assertNotIn(retired_copy.lower(), text)


if __name__ == "__main__":
    unittest.main()
