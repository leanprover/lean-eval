# Flavour-text audit inventory

The lifecycle-overhaul plan reserves the final prose and provenance review for
humans. The inventory tool makes that review finite and reproducible without
generating, repairing, or semantically judging any text. It does not establish
that existing prose was human-authored.

Run:

```console
python scripts/flavour_text_inventory.py \
  --json-output /tmp/lean-eval-flavour-text.json \
  --markdown-output /tmp/lean-eval-flavour-text.md
```

The output paths must not already exist. The tool writes the pair fail-closed:
it never knowingly leaves only one output behind.

The JSON report records, for every problem manifest, whether `notes`, `source`,
and `informal_solution` are present, their exact character and UTF-8 byte
counts, and SHA-256 digests of their exact TOML string values. The Markdown
rendering is a compact human work queue. A present field is not an approval:
every entry remains unreviewed until a human checks that it contains an
accurate informal statement, suitable citations and literature context, and
useful solving guidance whose authorship satisfies the no-LLM policy. Agents
must not generate, repair, or semantically approve hints.

Reports are generated artifacts and are not committed. The eventual human
audit record should contain the reviewer identity, review date, repository
commit, exact per-field digests, an `approved` or `needs-edit` outcome, and an
explicit provenance attestation. That makes later prose changes visible without
treating this inventory as a quality gate.
