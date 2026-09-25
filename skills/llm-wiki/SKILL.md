---
name: llm-wiki
description: Persistent engineering knowledge base for the user and AI agents.
---

## Purpose

The `LLM Wiki` is a persistent engineering knowledge base shared between the user and AI agents.

It preserves reusable engineering knowledge across tasks and sessions.

It is NOT:
- a session log
- a task tracker
- a progress journal
- a TODO list
- a record of routine coding activity

The goal is to preserve knowledge that can help solve similar problems in the future.

---

# Obsidian CLI

Use the Obsidian CLI for all wiki operations.

Vault:

```text
LLM Wiki
```

Create notes using:

```bash
obsidian vault="LLM Wiki" create name="PATH/Note title" content="CONTENT"
```

Search:

```bash
obsidian vault="LLM Wiki" search query="SEARCH TERMS"
```

When an existing note is found, read it before deciding whether to create or update knowledge.

---

# When to search

Search the wiki when:

* starting work on something that may have been solved before
* the user asks how something was previously solved
* the user asks to remember or recall previous work
* the user asks "what did we do?"
* the user asks "how did we solve this?"
* the user says "recordar", "acuérdate", or similar
* a technical topic may have existing engineering knowledge
* an unfamiliar project convention is encountered
* an existing architectural decision may affect the current task
* an architectural decision is about to be made

Use search terms derived from the current problem.

Example:

```bash
obsidian vault="LLM Wiki" search query="authentication"
```

When relevant existing knowledge is found, read it and use it as context before proceeding.

---

# When to save

Save knowledge when the result contains reusable information from:

* a completed bugfix
* an architectural or design decision
* a non-obvious codebase discovery
* a configuration or environment setup with reusable implications
* an established naming, structure, or engineering pattern
* an important technical constraint
* a user preference or engineering constraint that should affect future work

A completed task does NOT automatically deserve a note.

Ask:

> Will this information help me or another engineer solve a similar problem in the future?

If not, do not save it.

---

# Do not save

Do not create notes for:

* routine code changes
* temporary debugging information
* individual file modifications with no reusable lesson
* session progress
* "what I did today" summaries
* information obvious from the source code
* temporary TODOs or next steps
* duplicate knowledge
* ephemeral or temporary notes
* sensitive information such as API keys or passwords

---

# Knowledge types

Only use these categories unless the user explicitly requests another:

| Category     | Type           |
| ------------ | -------------- |
| Decisions    | `decision`     |
| Architecture | `architecture` |
| Bugfixes     | `bugfix`       |
| Patterns     | `pattern`      |
| Discoveries  | `discovery`    |

# Status

| Status      | Description    |
| ----------- | -------------- |
| seedling    | Initial note, may be incomplete or require further validation. |
| budding     | Note is developing and gaining more context or details. |
| evergreen   | Note is well-established, reliable, and expected to remain relevant over time. |

---

# Note locations

Organize notes using:

```text
LLM Wiki/
├── Decisions/
├── Architecture/
├── Bugfixes/
├── Patterns/
└── Discoveries/
```

Create each note inside its corresponding folder.

Examples:

```bash
obsidian vault="LLM Wiki" create name="Bugfixes/Fixed N+1 query in UserList" content="..."
obsidian vault="LLM Wiki" create name="Architecture/Use PostgreSQL for persistence" content="..."
obsidian vault="LLM Wiki" create name="Patterns/Repository pattern for persistence" content="..."
```

---

# Note structure

Every knowledge note should be an independent Markdown document.

Base structure:

```markdown
---
type: TYPE
status: seedling
tags:
  - relevant-tag
---

# Title

## What

One concise sentence describing what was established, discovered, or fixed.

## Why

Explain the reason, root cause, constraints, or motivation.

## Learned

Important technical details, gotchas, edge cases, limitations, or consequences.


## Related Knowledge

Knowledge graph or related notes that provide [[additional context link]].
```


Omit `Learned` when there is nothing useful to preserve.

The `type` must match the knowledge category.

---

# Titles

Titles must be:

* short
* specific
* searchable
* natural
* focused on reusable knowledge

Prefer:

```text
Fixed N+1 query in UserList
Use PostgreSQL for transactional persistence
Validate tenant context at API boundary
Use signals for derived UI state
PrimeFaces requires explicit AJAX update target
```

Avoid:

```text
Bug fix
Important
Today
Session notes
Task 5311
Things we learned
Work completed
```

The title describes the knowledge, not the task or session.

---

# Avoid duplicates

Before creating a note, search the wiki when the topic may already exist.

If an existing note covers the same knowledge:

1. Read the existing note.
2. Determine whether the new information changes or extends it.
3. Update the existing note when appropriate.
4. Do not create a second note covering the same knowledge.

Prefer one authoritative evolving note over fragmented notes.

For example, if this exists:

```text
LLM Wiki/Architecture/Authentication model.md
```

and the authentication architecture changes, update that note instead of creating:

```text
Authentication model v2.md
New authentication decision.md
Updated auth architecture.md
```

---

# Updating existing knowledge

Update an existing note when:

* an architectural decision evolves
* a bugfix gains additional information
* a documented pattern changes
* a discovery is refined by new evidence
* new edge cases are discovered
* the original knowledge becomes partially inaccurate

Preserve the note as the authoritative source.

Do not create a new note merely because the knowledge changed.

---

# Knowledge over activity

The wiki exists to preserve reusable knowledge.

Do not treat every completed task as documentation-worthy.

The correct question is:

> Will this information help solve a similar problem in the future?

If the answer is no, do not save it.

A difficult problem that produced a reusable solution should be documented.

A routine implementation that produced no reusable knowledge should not.

---

# Session close

Do not create:

* session summaries
* session logs
* progress reports
* temporary TODO notes

Before finishing a task, ensure that reusable knowledge discovered during the task has been appropriately saved or an existing note has been updated.

---

# After context compaction

After context compaction or reset:

1. Search the `LLM Wiki` for knowledge relevant to the current task.
2. Read relevant decisions, architecture, patterns, bugfixes, and discoveries.
3. Continue using existing knowledge instead of recreating documented decisions.
4. Do not create a compaction summary note.
