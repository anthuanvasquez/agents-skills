#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/anthuanvasquez/skills.git"
TEMP_DIR="/tmp/skills-feature-$(date +%s)"
PLATFORMS="${PLATFORMS:-none}"
GLOBAL_SKILLS_DIR="$HOME/.agents/skills"
CLONED_SOURCE=0

cleanup() {
  if [ "$CLONED_SOURCE" -eq 1 ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}

resolve_source_dir() {
  local script_dir
  script_dir="$(cd "$(dirname "$0")" && pwd)"

  # Preferred: packaged feature payload and core when distributed via GHCR.
  if [ -d "$script_dir/skills" ] && [ -f "$script_dir/scripts/install-core.sh" ]; then
    echo "$script_dir"
    return
  fi

  # Local development from this repository checkout.
  if [ -d "$script_dir/../../skills" ] && [ -f "$script_dir/../../scripts/install-core.sh" ]; then
    echo "$script_dir/../.."
    return
  fi

  # Fallback to repository clone when packaged files are not present.
  git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
  CLONED_SOURCE=1
  echo "$TEMP_DIR"
}

main() {
  trap cleanup EXIT
  local source_dir
  source_dir="$(resolve_source_dir)"

  # shellcheck source=/dev/null
  . "$source_dir/scripts/install-core.sh"

  skills_install_from_source "$source_dir" "$PLATFORMS" "$GLOBAL_SKILLS_DIR"
}

main "$@"
