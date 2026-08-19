#!/bin/bash

set -euo pipefail

ERRORS=0
PLATFORMS=""
PLATFORMS_EXPLICIT=0

usage() {
    echo "Usage: $0 [--platforms <none|gemini|copilot|pi|all|csv>]"
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

    if [ "$raw" = "all" ]; then
        echo "gemini,copilot,pi"
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

echo -e "\n--- Validating Google Gemini CLI ---"
if platform_enabled "gemini" "$NORMALIZED_PLATFORMS"; then
    check_exists "$HOME/.gemini/skills"
    check_exists "$HOME/.gemini/AGENTS.md"
else
    check_not_exists "$HOME/.gemini/skills"
    check_not_exists "$HOME/.gemini/AGENTS.md"
fi

echo -e "\n--- Validating GitHub Copilot ---"
if platform_enabled "copilot" "$NORMALIZED_PLATFORMS"; then
    check_exists "$HOME/.copilot/skills"
    check_exists "$HOME/.copilot/AGENTS.md"
else
    check_not_exists "$HOME/.copilot/skills"
    check_not_exists "$HOME/.copilot/AGENTS.md"
fi

echo -e "\n--- Validating PI ---"
if platform_enabled "pi" "$NORMALIZED_PLATFORMS"; then
    check_exists "$HOME/.pi/agent/skills"
    check_exists "$HOME/.pi/agent/AGENTS.md"
else
    check_not_exists "$HOME/.pi/agent/skills"
    check_not_exists "$HOME/.pi/agent/AGENTS.md"
fi

if [ $ERRORS -eq 0 ]; then
    echo -e "\n🎉 All tests passed successfully!"
    exit 0
else
    echo -e "\n💥 $ERRORS tests failed."
    exit 1
fi
