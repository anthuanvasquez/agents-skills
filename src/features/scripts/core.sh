#!/bin/bash

set -euo pipefail

skills_normalize_platforms() {
  local raw="${1:-none}"
  raw="$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')"
  raw="${raw// /}"

  if [ "$raw" = "" ]; then
    raw="none"
  fi

  if [ "$raw" = "all" ]; then
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

skills_install_copilot_plugin() {
  local source_dir="$1"
  local plugin_dir="$HOME/.copilot/plugins/agents-skills"
  local repo_url="https://github.com/anthuanvasquez/agents-skills.git"

  mkdir -p "$(dirname "$plugin_dir")"
  skills_path_reset "$plugin_dir"

  if [ -f "$source_dir/plugin.json" ]; then
    mkdir -p "$plugin_dir"
    cp "$source_dir/plugin.json" "$plugin_dir/plugin.json"
    cp "$source_dir/mcp.json" "$plugin_dir/mcp.json"
    cp -r "$source_dir/skills" "$plugin_dir/skills"
    cp -r "$source_dir/com.github.copilot" "$plugin_dir/com.github.copilot"
  else
    git clone --depth 1 "$repo_url" "$plugin_dir"
  fi

  echo "Installed Copilot plugin to $plugin_dir"
}

skills_configure_copilot() {
  local source_dir="$1"
  skills_install_copilot_plugin "$source_dir"
}

skills_cleanup_unselected_platforms() {
  local normalized="$1"

  case ",$normalized," in
    *,copilot,*)
      ;;
    *)
      skills_path_reset "$HOME/.copilot/skills"
      skills_path_reset "$HOME/.copilot/AGENTS.md"
      ;;
  esac

  # Cleanup legacy platform folders from previous installer versions.
  skills_path_reset "$HOME/.copilot/agents"
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
