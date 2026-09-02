# Skills

An [Agent Plugin](https://code.visualstudio.com/docs/agent-customization/agent-plugins) that bundles portable **skills**, **custom agents**, **slash commands**, and **MCP servers** for GitHub Copilot, while also exposing the same skills as a global `~/.agents/skills` directory usable by any AI tool that follows that convention.

## Quick Start

Install globally with platform wiring prompts:

```bash
curl -fsSL https://raw.githubusercontent.com/anthuanvasquez/agents-skills/main/install.sh | bash
```

Install non-interactive and wire GitHub Copilot:

```bash
curl -fsSL https://raw.githubusercontent.com/anthuanvasquez/agents-skills/main/install.sh | bash -s -- --platforms copilot --non-interactive
```

Supported platform values:

- `none` — only install skills to `~/.agents/skills`.
- `copilot` — also copy Copilot-specific assets to the standard user directories.

Default behavior installs `skills/` into `~/.agents/skills`.

Selecting `copilot` copies:

- `com.github.copilot/agents/*` → `~/.copilot/agents/`
- `com.github.copilot/commands/*` → `~/.copilot/prompts/`
- `com.github.copilot/instructions/*` → `~/.copilot/instructions/`

## Copilot Agent Plugin

This repository is also a valid Agent Plugins 1.0 package. You can import it as a plugin in VS Code or the GitHub Copilot app without running the install script:

1. Open the Command Palette and run **Chat: Install Plugin From Source**.
2. Enter `https://github.com/anthuanvasquez/agents-skills`.

When imported as a plugin, Copilot discovers:

- **Skills** from [`skills/`](skills/)
- **Custom agents** from [`com.github.copilot/agents/`](com.github.copilot/agents/)
- **Slash commands** (prompt files) from [`com.github.copilot/commands/`](com.github.copilot/commands/)
- **Instructions** from [`com.github.copilot/instructions/`](com.github.copilot/instructions/)
- **MCP servers** from [`mcp.json`](mcp.json)

> The global install script does **not** copy `plugin.json` or `mcp.json` into `~/.copilot/`; those are only consumed when the repo is imported as a plugin.

## Dev Container Feature

This repository ships a Dev Container Feature consumable from GHCR. The feature installs the skills globally and optionally wires GitHub Copilot.

Feature option:

- `platforms` (string): `none|copilot`

Example:

```json
{
	"features": {
		"ghcr.io/anthuanvasquez/agents-skills/features:latest": {
			"platforms": "copilot"
		}
	}
}
```

An example consumer exists at [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json).

## Available Skills

| Skill | Description |
| :--- | :--- |
| **API Design Principles** | REST and GraphQL best practices for maintainable APIs. |
| **Brainstorming** | Socratic questioning protocol for complex requests and new features. |
| **Changelog Generator** | Automated customer-facing release notes from commit history. |
| **Error Handling Patterns** | Resilient error propagation and graceful degradation strategies. |
| **Git Commit** | Conventional commits with intelligent staging and message generation. |
| **Improve Codebase Architecture** | Scan a codebase for deepening opportunities and produce a visual HTML report. |
| **Interface Design** | Expert guidance for dashboards, admin panels, and interactive tools. |
| **Perfect Code Review** | Structured pull request code review using the PERFECT framework. |
| **Systematic Debugging** | Professional root-cause analysis and debugging protocol. |
| **Test-Driven Development** | Test-first development guidance and patterns. |


## Test

```zsh
docker build -t skills-test .
docker run -it -v $(pwd):/home/test/skills skills-test bash

# inside container
cd /home/test/skills
./install.sh --platforms copilot --non-interactive
./test.sh

# or explicit
./test.sh --platforms copilot
```

## License
MIT
