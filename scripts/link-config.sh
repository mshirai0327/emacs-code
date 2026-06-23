#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
target="$config_home/emacs"
backup=0

case "${1:-}" in
  --backup)
    backup=1
    ;;
  "" )
    ;;
  * )
    printf 'Usage: %s [--backup]\n' "$0" >&2
    exit 2
    ;;
esac

mkdir -p "$config_home"

if [ -L "$target" ]; then
  current="$(readlink "$target")"
  if [ "$current" = "$repo_root" ]; then
    printf 'Already linked: %s -> %s\n' "$target" "$repo_root"
    exit 0
  fi
fi

if [ -e "$target" ] || [ -L "$target" ]; then
  if [ "$backup" -eq 0 ]; then
    printf 'Refusing to overwrite existing %s\n' "$target" >&2
    printf 'Run with --backup to move it aside first.\n' >&2
    exit 1
  fi

  timestamp="$(date +%Y%m%d%H%M%S)"
  backup_target="${target}.backup.${timestamp}"
  mv "$target" "$backup_target"
  printf 'Backed up %s to %s\n' "$target" "$backup_target"
fi

ln -s "$repo_root" "$target"
printf 'Linked %s -> %s\n' "$target" "$repo_root"
