#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/anthuanvasquez/skills.git"
TEMP_DIR="/tmp/skills-temp-$(date +%s)"
GLOBAL_SKILLS_DIR="$HOME/.agents/skills"
PLATFORMS="${PLATFORMS:-}"
NON_INTERACTIVE=0
SOURCE_DIR_OVERRIDE=""

usage() {
  echo "Usage: $0 [--platforms <none|gemini|copilot|pi|all|csv>] [--non-interactive] [--source-dir <path>]"
  echo ""
  echo "Examples:"
  echo "  $0"
  echo "  $0 --platforms all --non-interactive"
  echo "  PLATFORMS=gemini,copilot $0 --non-interactive"
}

parse_args() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --platforms)
        if [ $# -lt 2 ]; then
          echo "Missing value for --platforms"
          exit 1
        fi
        PLATFORMS="$2"
        shift 2
        ;;
      --non-interactive)
        NON_INTERACTIVE=1
        shift
        ;;
      --source-dir)
        if [ $# -lt 2 ]; then
          echo "Missing value for --source-dir"
          exit 1
        fi
        SOURCE_DIR_OVERRIDE="$2"
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
}

interactive_platform_prompt() {
  echo ""
  echo "Which AI platforms do you want to configure?"
  echo "- none"
  echo "- gemini"
  echo "- copilot"
  echo "- pi"
  echo "- all"
  echo "You can also combine values, for example: gemini,copilot"
  read -r -p "Select platforms: " OPTIONS

  if [ -z "${OPTIONS// }" ]; then
    PLATFORMS="none"
    return
  fi

  local mapped=""
  local token
  local normalized
  normalized="$(printf '%s' "$OPTIONS" | tr '[:upper:]' '[:lower:]')"
  normalized="${normalized//,/ }"

  for token in $normalized; do
    case "$token" in
      0) token="none" ;;
      1) token="gemini" ;;
      2) token="copilot" ;;
      3) token="pi" ;;
      4) token="all" ;;
    esac

    if [ -z "$mapped" ]; then
      mapped="$token"
    else
      mapped="$mapped,$token"
    fi
  done

  PLATFORMS="$mapped"
}

load_core() {
  local source_dir=""

  if [ -n "$SOURCE_DIR_OVERRIDE" ]; then
    source_dir="$SOURCE_DIR_OVERRIDE"
  elif [ -d "skills" ] && [ -f "plugin.json" ] && [ -f "src/features/scripts/install-core.sh" ]; then
    source_dir="$(pwd)"
    echo "Using local source files."
  else
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1
    source_dir="$TEMP_DIR"
  fi

  # shellcheck source=/dev/null
  . "$source_dir/src/features/scripts/install-core.sh"
  SKILLS_SOURCE_DIR="$source_dir"
}

cleanup() {
  if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}

main() {
  parse_args "$@"
  trap cleanup EXIT
  load_core

  if [ -z "$PLATFORMS" ] && [ "$NON_INTERACTIVE" -eq 0 ]; then
    interactive_platform_prompt
  fi

  if [ -z "$PLATFORMS" ]; then
    PLATFORMS="none"
  fi

  skills_install_from_source "$SKILLS_SOURCE_DIR" "$PLATFORMS" "$GLOBAL_SKILLS_DIR"
  echo ""
  echo "✅ Installation complete"
}

main "$@"
