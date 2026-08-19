# Skills

Repository to hold standardized guidance, agent rules, and scaffold templates for applying AI agents (Google Gemini, GitHub Copilot, and PI) safely and productively in engineering workflows.

## Quick Start

Install globally with platform wiring prompts:

```bash
curl -fsSL https://raw.githubusercontent.com/anthuanvasquez/skills/main/install.sh | bash
```

Install non-interactive:

```bash
curl -fsSL https://raw.githubusercontent.com/anthuanvasquez/skills/main/install.sh | bash -s -- --platforms gemini,copilot --non-interactive
```

Supported platform values (for both `--platforms` and the interactive prompt):

- `none`
- `gemini`
- `copilot`
- `pi`
- `all`
- Comma-separated combinations like `gemini,copilot`

Default behavior installs `skills/` into `~/.agents/skills` and only wires selected platforms.

## Dev Container Feature

This repository ships a Dev Container Feature consumable from GHCR.

The feature is designed to keep this repository as the source of truth:

- Uses packaged feature files when available.
- Uses local repository source during local development.
- Falls back to cloning this repository when needed.

Feature option:

- `platforms` (string): `none|gemini|copilot|pi|all|csv`

Example:

```json
{
	"features": {
		"ghcr.io/anthuanvasquez/skills/features:latest": {
			"platforms": "none"
		}
	}
}
```

An example consumer exists at `.devcontainer/devcontainer.json`.

## Available Skills

### Core Workflow & Automation
Skills focused on the development lifecycle and git automation.

| Skill | Description |
| :--- | :--- |
| **Brainstorming** | Socratic questioning protocol for complex requests and new features. |
| **Branch PR** | Pull Request creation workflow following the issue-first system. |
| **Changelog Generator** | Automated customer-facing release notes from commit history. |
| **Git Commit** | Conventional commits with intelligent staging and message generation. |
| **Issue Creation** | GitHub issue creation workflow (Bug Reports, Feature Requests). |
| **Skill Registry** | Scans and generates project skill registry for orchestrator access. |
| **Second Brain Architect** | Expert guidance for notes taking and knowledge generation. |

### Engineering Standards
Deep technical expertise for building robust and scalable systems.

| Skill | Description |
| :--- | :--- |
| **Systematic Debugging** | Professional root-cause analysis and debugging protocol. |
| **API Design Principles** | REST and GraphQL best practices for maintainable APIs. |
| **Error Handling Patterns** | Resilient error propagation and graceful degradation strategies. |
| **TypeScript Expert** | Type-level programming, performance, and modern tooling mastery. |
| **Perfect Code Review** | Structured pull request code review using the PERFECT framework. |

### Design & Frontend
Building premium user interfaces and high-performance applications.

| Skill | Description |
| :--- | :--- |
| **Interface Design** | Expert guidance for dashboards, admin panels, and interactive tools. |
| **Tailwind Design System** | Scalable UI patterns with Tailwind CSS v4 and design tokens. |
| **React Best Practices** | Vercel-grade performance optimization for React and Next.js. |

## Available Workflows
Commands to streamline common development tasks.

| Command | Description |
| :--- | :--- |
| **`/brainstorm`** | Structured Idea Exploration |
| **`/commit`** | Create Atomic Commits |
| **`/create`** | Create Application |
| **`/debug`** | Systematic Problem Investigation |
| **`/deploy`** | Production Deployment |
| **`/enhance`** | Update Application |
| **`/orchestrate`** | Multi-Agent Orchestration |
| **`/plan`** | Project Planning Mode |
| **`/preview`** | Preview Management |
| **`/status`** | Show Status |
| **`/test`** | Test Generation and Execution |


## Test

```zsh
docker build -t test-skills-installer .
docker run -it -v $(pwd):/home/testuser/skills test-skills-installer bash

# inside container
cd /home/testuser/skills
./install.sh --platforms gemini --non-interactive
./test-install.sh
# or explicit
./test-install.sh --platforms gemini
```

## License
MIT
