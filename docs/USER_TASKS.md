# User-Dependent Tasks

このファイルは、Codex 側で勝手に実行しない作業を管理するためのタスクリストです。

対象は、`sudo` が必要な作業、既存ユーザー設定を変更する作業、global install 方針などユーザー判断が必要な作業です。

## Current Status

最終確認: 2026-06-23 JST

`make check` と `bash scripts/doctor.sh` は成功しています。

| Area | Status | Notes |
| --- | --- | --- |
| WSLg | Done | `DISPLAY=:0`, `WAYLAND_DISPLAY=wayland-0` |
| Git | Done | `/usr/bin/git` |
| ripgrep | Done | `rg` is available |
| Go | Done | `/usr/bin/go` |
| gopls | Installed; validation deferred | `/home/mizuho/go/bin/gopls`, version `v0.22.0`; no current personal Go project |
| Node/npm | Done | nvm managed Node/npm are available |
| TypeScript LSP | Installed; workflow validation pending | `typescript-language-server 5.3.0` |
| Emacs GUI | Done | `/usr/bin/emacs`; GUI confirmed via `window-system => x` |
| fd/fdfind | Done | `/usr/bin/fdfind` |
| Config symlink | Done | `~/.config/emacs -> /home/mizuho/develop/emacs-code` |
| First Emacs launch | Done | GUI window launched through WSLg |
| Batch check | Done | `make check` loads `init.el` successfully |
| Japanese font | Done | Noto CJK font detected |

## Completed User Actions

### 1. Install GUI Emacs and fd-find

Owner: user

Reason: requires `sudo` and changes OS packages.

Status: done

Command used in WSL:

```sh
sudo apt update
sudo apt install emacs-gtk fd-find
```

Verification:

```sh
emacs --version
fdfind --version
bash scripts/doctor.sh
```

Current result: `doctor.sh` no longer reports `MISSING emacs`. `fdfind` is detected.

### 2. Decide Whether to Link This Repo as `~/.config/emacs`

Owner: user

Reason: may overwrite or replace existing personal Emacs configuration.

Status: done

Check first:

```sh
ls -la ~/.config/emacs ~/.emacs.d 2>/dev/null
```

If re-running on a clean machine with no existing `~/.config/emacs`:

```sh
bash scripts/link-config.sh
```

If re-running on a machine with an existing `~/.config/emacs` and it is okay to move it aside:

```sh
bash scripts/link-config.sh --backup
```

Verification:

```sh
ls -la ~/.config/emacs
```

Current result: `~/.config/emacs` points to this repository.

### 3. Launch Emacs Once

Owner: user

Reason: starts a GUI app and downloads Emacs packages on first launch.

Status: done

Run:

```sh
emacs &
```

Current result: a GUI Emacs window appears through WSLg.

### 4. Run Local Checks After First Launch

Owner: Codex or user

Reason: after Emacs and packages exist, the config can be loaded in batch mode.

Status: done

Run:

```sh
make doctor
make check
```

Current result: `make check` loads `init.el` without errors. `make doctor` reports all checked tools as present.

### 5. Install Japanese Fonts

Owner: user

Reason: requires `sudo` and changes OS packages.

Status: done

Run in WSL:

```sh
sudo apt update
sudo apt install fonts-noto-cjk
```

Verification:

```sh
fc-list :lang=ja family | head
bash scripts/doctor.sh
```

Current result: `doctor.sh` detects a Noto CJK Japanese font.

## Pending Workflow Validation

### 1. Validate TypeScript In A Real Project

Owner: user and Codex

Status: pending

The TypeScript language server and Eglot configuration are present. The
remaining work is to validate the complete editing workflow in
`embodied-reflecta` or `embodied-reflecta-gpt`:

- automatic Eglot startup
- go to definition and back
- find references
- rename
- diagnostics
- format/import behavior

This is tracked as Phase 0 in [ROADMAP.md](ROADMAP.md).

### 2. Validate gopls When A Go Project Is Available

Owner: user and Codex

Status: deferred

`gopls v0.22.0` and its Eglot configuration are installed. Since current
personal development is TypeScript-centered, full Go workflow validation is
deferred until there is a real Go project to test.

### 3. Decide Whether `C-n` Should Override Next-Line

Owner: user

Status: deferred until Navigate popup is implemented

The reliable binding will be `C-c i n`. IntelliJ-compatible mode can bind
`C-n` to the Navigate popup, but this replaces the standard Emacs next-line
binding. The choice will remain configurable.

## Optional User Decisions

These are not required for the first usable Emacs setup.

| Decision | Default | When to revisit |
| --- | --- | --- |
| Windows native Emacs | Skip | after WSL GUI Emacs is stable |
| Replace VS Code workflow | Do not replace | after TypeScript navigation and layout feel reliable |
| DB UI inside Emacs | Skip | when a concrete DB workflow is needed |
| AI terminal layout | Use shell/eshell first | after base tab/window layout is comfortable |
| npm global policy | Keep current nvm setup | if global packages become hard to reproduce |

## Updating This File

When a user-dependent task is completed, update the corresponding status in `Current Status`.

The preferred loop is:

```sh
bash scripts/doctor.sh
make check
```

Then record what changed here.
