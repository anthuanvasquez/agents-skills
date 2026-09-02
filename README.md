# Skills

An [Agent Plugin](https://code.visualstudio.com/docs/agent-customization/agent-plugins) that bundles portable **skills**, **custom agents**, **slash commands**, and **MCP servers** for GitHub Copilot, while also wiring the same skills into Google Gemini CLI and PI.

## Quick Start

Install globally with platform wiring prompts:

```bash
curl -fsSL https://raw.githubusercontent.com/anthuanvasquez/agents-skills/main/install.sh | bash
```

Install non-interactive:

```bash
curl -fsSL https://raw.githubusercontent.com/anthuanvasquez/agents-skills/main/install.sh | bash -s -- --platforms gemini,copilot --non-interactive
```

Supported platform values (for both `--platforms` and the interactive prompt):

- `none`
- `gemini`
- `copilot`
- `pi`
- `all`
- Comma-separated combinations like `gemini,copilot`

Default behavior installs `skills/` into `~/.agents/skills`. Selecting `copilot` installs the repository as a Copilot Agent Plugin under `~/.copilot/installed-plugins/_direct/github--anthuanvasquez--skills/`.

## Copilot Agent Plugin

This repository is also a valid Agent Plugins 1.0 package. You can install it directly in VS Code:

1. Open the Command Palette and run **Chat: Install Plugin From Source**.
2. Enter `https://github.com/anthuanvasquez/agents-skills`.

Once installed, Copilot discovers:

- **Skills** from [`skills/`](skills/)
- **Custom agents** from [`com.github.copilot/agents/`](com.github.copilot/agents/)
- **Slash commands** (prompt files) from [`com.github.copilot/commands/`](com.github.copilot/commands/)
- **MCP servers** from [`mcp.json`](mcp.json)

## Dev Container Feature

This repository ships a Dev Container Feature consumable from GHCR. The feature clones this repository as a Copilot Agent Plugin and wires the skills to Gemini and PI as requested.

Feature option:

- `platforms` (string): `none|gemini|copilot|pi|all|csv`

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
