---
applyTo: "**"
description: This file contains instructions for using the LLM Wiki Obsidian vault.
---

# LLM Wiki

The `LLM Wiki` Obsidian vault is the persistent engineering knowledge base.

It stores reusable engineering knowledge, not session history, temporary progress, or activity logs.

## Core rules

- Use the `LLM Wiki` when reusable engineering knowledge is discovered, changed, or needed.
- Search the wiki before making assumptions about existing architectural decisions, patterns, conventions, or previously solved problems.
- Save knowledge when a task produces a reusable decision, architecture, bugfix, pattern, discovery, or technical constraint.
- Update an existing note instead of creating duplicate knowledge.
- Never create session summaries, progress logs, temporary TODOs, or routine activity notes.
- Prefer knowledge that can help solve a similar problem in the future.
- Do not document information that is obvious from the source code unless it has an important non-obvious implication.

## Persistence

Use the Obsidian CLI to read and write the `LLM Wiki` vault.

All persistent engineering knowledge must be stored in the `LLM Wiki` vault.

For the detailed workflow, note structure, categories, search/update rules, and CLI operations, follow the `Obsidian LLM Wiki` skill.
