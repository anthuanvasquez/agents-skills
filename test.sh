#!/bin/bash

set -euo pipefail

ERRORS=0
PLATFORMS=""
PLATFORMS_EXPLICIT=0

usage() {
    echo "Usage: $0 [--platforms <none|copilot|all>]"
    echo "If --platforms is omitted, values are auto-detected from ~/.agents/.skills-install-state"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --platforms)
            if [ $# -lt 2 ]; then
                echo "Missing value for --platforms"
                exit 1
            fi
            PLATFORMS="$2"
            PLATFORMS_EXPLICIT=1
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

normalize_platforms() {
    local raw
    raw="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
    raw="${raw// /}"

    if [ "$raw" = "copilot" ]; then
        echo "copilot"
        return
    fi

    if [ -z "$raw" ] || [ "$raw" = "none" ]; then
        echo "none"
        return
    fi

    echo "$raw"
}

load_platforms_from_state() {
    local state_file="$HOME/.agents/.skills-install-state"

    if [ ! -f "$state_file" ]; then
        echo "none"
        return
    fi

    local state_platforms
    state_platforms="$(awk -F= '/^platforms=/{print $2}' "$state_file" | head -n 1)"

    if [ -z "$state_platforms" ]; then
        echo "none"
    else
        echo "$state_platforms"
    fi
}

platform_enabled() {
    local platform="$1"
    local normalized="$2"
    case ",$normalized," in
        *",$platform,"*) return 0 ;;
        *) return 1 ;;
    esac
}

check_exists() {
    if [ ! -e "$1" ]; then
        echo "❌ Missing: $1"
        ERRORS=$((ERRORS+1))
    else
        echo "✅ Found: $1"
    fi
}

check_not_exists() {
    if [ -e "$1" ]; then
        echo "❌ Should not exist: $1"
        ERRORS=$((ERRORS+1))
    else
        echo "✅ Absent: $1"
    fi
}

if [ "$PLATFORMS_EXPLICIT" -eq 0 ]; then
    PLATFORMS="$(load_platforms_from_state)"
    echo "Auto-detected platforms from install state: $PLATFORMS"
fi

NORMALIZED_PLATFORMS="$(normalize_platforms "$PLATFORMS")"

echo "Validating global install"
check_exists "$HOME/.agents/skills"
check_exists "$HOME/.agents/.skills-install-state"

COPILOT_AGENTS_DIR="$HOME/.copilot/agents"
COPILOT_PROMPTS_DIR="$HOME/.copilot/prompts"
COPILOT_INSTRUCTIONS_DIR="$HOME/.copilot/instructions"
SKILL_NAMES=(
    api-design-principles
    brainstorming
    changelog-generator
    error-handling-patterns
    git-commit
    improve-codebase-architecture
    interface-design
    perfect-code-review
    systematic-debugging
    tdd
)

echo -e "\n--- Validating GitHub Copilot ---"
if platform_enabled "copilot" "$NORMALIZED_PLATFORMS"; then
    check_exists "$COPILOT_AGENTS_DIR/code-reviewer.agent.md"
    check_exists "$COPILOT_AGENTS_DIR/security-auditor.agent.md"
    check_exists "$COPILOT_AGENTS_DIR/test-engineer.agent.md"
    check_exists "$COPILOT_AGENTS_DIR/thinking-partner.agent.md"
    check_exists "$COPILOT_PROMPTS_DIR/commit.prompt.md"
    check_exists "$COPILOT_INSTRUCTIONS_DIR/copilot.instructions.md"
else
    check_not_exists "$COPILOT_AGENTS_DIR"
    check_not_exists "$COPILOT_PROMPTS_DIR"
    check_not_exists "$COPILOT_INSTRUCTIONS_DIR"
fi

if [ $ERRORS -eq 0 ]; then
    echo -e "\n🎉 All tests passed successfully!"
    exit 0
else
    echo -e "\n💥 $ERRORS tests failed."
    exit 1
fi
