#!/usr/bin/env bash
set -u

missing_required=0
missing_recommended=0

ok() {
  printf 'OK       %s\n' "$1"
}

warn() {
  printf 'WARN     %s\n' "$1"
}

missing_required() {
  printf 'MISSING  %s\n' "$1"
  missing_required=1
}

missing_recommended() {
  printf 'MISSING  %s\n' "$1"
  missing_recommended=1
}

check_required() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1: $(command -v "$1")"
  else
    missing_required "$1"
  fi
}

check_recommended() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1: $(command -v "$1")"
  else
    missing_recommended "$1"
  fi
}

check_go_tool() {
  tool="$1"
  fallback="$HOME/go/bin/$tool"

  if command -v "$tool" >/dev/null 2>&1; then
    ok "$tool: $(command -v "$tool")"
  elif [ -x "$fallback" ]; then
    ok "$tool: $fallback (not on shell PATH; Emacs config adds it)"
  else
    missing_recommended "$tool"
  fi
}

check_japanese_font() {
  if ! command -v fc-list >/dev/null 2>&1; then
    missing_recommended "fontconfig fc-list"
    return
  fi

  if fc-list :lang=ja family | grep -q .; then
    ok "Japanese font: $(fc-list :lang=ja family | head -n 1)"
  else
    missing_recommended "Japanese font (suggested package: fonts-noto-cjk)"
  fi
}

printf '== Platform ==\n'
if grep -qi microsoft /proc/version 2>/dev/null; then
  ok "WSL detected"
else
  warn "WSL was not detected"
fi

if [ -n "${DISPLAY:-}" ]; then
  ok "DISPLAY=$DISPLAY"
else
  warn "DISPLAY is empty"
fi

if [ -n "${WAYLAND_DISPLAY:-}" ]; then
  ok "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
else
  warn "WAYLAND_DISPLAY is empty"
fi

printf '\n== Required tools ==\n'
check_required git
check_required emacs
check_required rg

printf '\n== Recommended search tools ==\n'
if command -v fd >/dev/null 2>&1; then
  ok "fd: $(command -v fd)"
elif command -v fdfind >/dev/null 2>&1; then
  ok "fdfind: $(command -v fdfind)"
else
  missing_recommended "fd or fdfind"
fi

printf '\n== GUI and Japanese text ==\n'
check_japanese_font

printf '\n== Language toolchains ==\n'
check_recommended go
check_go_tool gopls
check_recommended node
check_recommended npm
check_recommended typescript-language-server

printf '\n== Suggested install commands ==\n'
printf 'sudo apt update\n'
printf 'sudo apt install emacs-gtk git ripgrep fd-find\n'
printf 'sudo apt install fonts-noto-cjk\n'
printf 'go install golang.org/x/tools/gopls@latest\n'
printf 'npm install -g typescript typescript-language-server\n'

if [ "$missing_required" -ne 0 ]; then
  printf '\nRequired tools are missing.\n'
  exit 1
fi

if [ "$missing_recommended" -ne 0 ]; then
  printf '\nRequired tools are present, but recommended tools are missing.\n'
  exit 2
fi

printf '\nAll checked tools are present.\n'
