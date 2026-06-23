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
| gopls | Done | `/home/mizuho/go/bin/gopls` |
| Node/npm | Done | nvm managed Node/npm are available |
| TypeScript LSP | Done | `typescript-language-server` is available |
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

## Optional User Decisions

These are not required for the first usable Emacs setup.

| Decision | Default | When to revisit |
| --- | --- | --- |
| Windows native Emacs | Skip | after WSL GUI Emacs is stable |
| Replace VS Code workflow | Do not replace | after Go/TypeScript navigation feels reliable |
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

## user memo

色味をvscodeに
タブ分割をvscodeに
複数repo
