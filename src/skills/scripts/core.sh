#!/bin/bash

set -euo pipefail

skills_normalize_platforms() {
  local raw="${1:-none}"
  raw="$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')"
  raw="${raw// /}"

  if [ "$raw" = "" ]; then
    raw="none"
  fi

  if [ "$raw" = "copilot" ]; then
    printf '%s' "copilot"
    return
  fi

  if [ "$raw" = "none" ]; then
    printf '%s' "none"
    return
  fi

  local validated=()
  local token
  IFS=',' read -r -a tokens <<< "$raw"
  for token in "${tokens[@]}"; do
    case "$token" in
      copilot)
        validated+=("$token")
        ;;
      none)
        ;;
      "")
        ;;
      *)
        echo "Invalid platform token: $token"
        exit 1
        ;;
    esac
  done

  if [ ${#validated[@]} -eq 0 ]; then
    printf '%s' "none"
    return
  fi

  local dedup=""
  local item
  for item in "${validated[@]}"; do
    case ",$dedup," in
      *",$item,"*)
        ;;
      *)
        if [ -z "$dedup" ]; then
          dedup="$item"
        else
          dedup="$dedup,$item"
        fi
        ;;
    esac
  done

  printf '%s' "$dedup"
}

skills_path_reset() {
  local target="$1"
  if [ -L "$target" ] || [ -d "$target" ] || [ -f "$target" ]; then
    rm -rf "$target"
  fi
}

skills_link_to_global() {
  local global_dir="$1"
  local link_path="$2"
  skills_path_reset "$link_path"
  ln -s "$global_dir" "$link_path"
}

skills_copy_file_if_present() {
  local source_file="$1"
  local target_file="$2"

  if [ -f "$source_file" ]; then
    cp "$source_file" "$target_file"
  fi
}

skills_install_global_payload() {
  local source_dir="$1"
  local global_dir="$2"

  if [ ! -d "$source_dir/skills" ]; then
    echo "Missing skills payload in source dir: $source_dir"
    exit 1
  fi

  mkdir -p "$HOME/.agents"
  skills_path_reset "$global_dir"
  cp -r "$source_dir/skills" "$global_dir"
}

skills_install_copilot_components() {
  local source_dir="$1"
  local copilot_dir="$source_dir/com.github.copilot"

  if [ ! -d "$copilot_dir" ]; then
    echo "Missing Copilot payload in source dir: $source_dir"
    exit 1
  fi

  # Reset managed directories so the install remains idempotent, then recreate them.
  skills_path_reset "$HOME/.copilot/agents"
  skills_path_reset "$HOME/.copilot/prompts"
  skills_path_reset "$HOME/.copilot/instructions"
  mkdir -p "$HOME/.copilot/agents"
  mkdir -p "$HOME/.copilot/prompts"
  mkdir -p "$HOME/.copilot/instructions"

  if [ -d "$copilot_dir/agents" ]; then
    cp -r "$copilot_dir/agents/"* "$HOME/.copilot/agents/"
  fi

  if [ -d "$copilot_dir/commands" ]; then
    cp -r "$copilot_dir/commands/"* "$HOME/.copilot/prompts/"
  fi

  if [ -d "$copilot_dir/instructions" ]; then
    cp -r "$copilot_dir/instructions/"* "$HOME/.copilot/instructions/"
  fi

  echo "Installed Copilot components to ~/.copilot/{agents,prompts,instructions}"
}

skills_configure_copilot() {
  local source_dir="$1"
  skills_install_copilot_components "$source_dir"
}

skills_cleanup_unselected_platforms() {
  local normalized="$1"

  case ",$normalized," in
    *,copilot,*)
      ;;
    *)
      skills_path_reset "$HOME/.copilot/agents"
      skills_path_reset "$HOME/.copilot/prompts"
      skills_path_reset "$HOME/.copilot/instructions"
      ;;
  esac

  # Cleanup legacy locations from previous installer versions.
  skills_path_reset "$HOME/.copilot/plugins/agents-skills"
  skills_path_reset "$HOME/.copilot/skills"
  skills_path_reset "$HOME/.copilot/AGENTS.md"
}

skills_write_state() {
  local source_dir="$1"
  local platforms="$2"
  local global_dir="$3"

  mkdir -p "$HOME/.agents"
  cat > "$HOME/.agents/.skills-install-state" <<EOF
version=1
installed_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
platforms=$platforms
global_dir=$global_dir
source_dir=$source_dir
EOF
}

skills_install_from_source() {
  local source_dir="$1"
  local platforms_raw="${2:-none}"
  local global_dir="${3:-$HOME/.agents/skills}"

  local normalized
  normalized="$(skills_normalize_platforms "$platforms_raw")"

  echo "Installing skills globally to $global_dir"
  skills_install_global_payload "$source_dir" "$global_dir"

  skills_cleanup_unselected_platforms "$normalized"

  case ",$normalized," in
    *,copilot,*)
      echo "Configuring GitHub Copilot"
      skills_configure_copilot "$source_dir"
      ;;
  esac

  skills_write_state "$source_dir" "$normalized" "$global_dir"
}
