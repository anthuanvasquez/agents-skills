---
name: create-commits
description: Split repository changes into atomic commits.
---

Use the `git-commit` skill to analyze all pending changes and create atomic commits.

Rules:

- One responsibility per commit
- One intent per commit
- Never mix unrelated changes
- Prefer the smallest logical commit

Before committing:

1. Show the proposed commit plan.
2. Request approval.
3. Execute.

If grouping is unclear, ask the user.
