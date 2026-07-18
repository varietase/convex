# Git decision-ledger hook

Install with `git config core.hooksPath hooks` and `chmod +x hooks/pre-commit`. It blocks ADR changes without a same-commit Decision Ledger update and reminds on invariant-sensitive surfaces. This is git-layer enforcement, not a Kiro hook.
