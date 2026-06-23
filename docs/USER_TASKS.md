# User-Dependent Tasks

このファイルは、Codex 側で勝手に実行しない作業を管理するためのタスクリストです。

対象は、`sudo` が必要な作業、既存ユーザー設定を変更する作業、global install 方針などユーザー判断が必要な作業です。

## Current Status

作成時点の `bash scripts/doctor.sh` では、次の状態です。

| Area | Status | Notes |
| --- | --- | --- |
| WSLg | Done | `DISPLAY=:0`, `WAYLAND_DISPLAY=wayland-0` |
| Git | Done | `/usr/bin/git` |
| ripgrep | Done | `rg` is available |
| Go | Done | `/usr/bin/go` |
| gopls | Done | `/home/mizuho/go/bin/gopls` |
| Node/npm | Done | nvm managed Node/npm are available |
| TypeScript LSP | Done | `typescript-language-server` is available |
| Emacs GUI | Pending user action | `emacs` command is missing |
| fd/fdfind | Pending user action | recommended for faster file finding |
| Config symlink | Pending user action | changes `~/.config/emacs` |
| First Emacs launch | Pending Emacs install | downloads Emacs packages |
| Batch check | Pending Emacs install | `make check` needs `emacs` |

## Required User Actions

### 1. Install GUI Emacs and fd-find

Owner: user

Reason: requires `sudo` and changes OS packages.

Run in WSL:

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

Expected result: `doctor.sh` no longer reports `MISSING emacs`. `fd` or `fdfind` should also be detected.

### 2. Decide Whether to Link This Repo as `~/.config/emacs`

Owner: user

Reason: may overwrite or replace existing personal Emacs configuration.

Check first:

```sh
ls -la ~/.config/emacs ~/.emacs.d 2>/dev/null
```

If there is no existing `~/.config/emacs`:

```sh
bash scripts/link-config.sh
```

If there is an existing `~/.config/emacs` and it is okay to move it aside:

```sh
bash scripts/link-config.sh --backup
```

Verification:

```sh
ls -la ~/.config/emacs
```

Expected result: `~/.config/emacs` points to this repository.

### 3. Launch Emacs Once

Owner: user

Reason: starts a GUI app and downloads Emacs packages on first launch.

Run:

```sh
emacs &
```

Expected result: a GUI Emacs window appears through WSLg, and the first launch downloads packages from GNU ELPA / NonGNU ELPA / MELPA.

### 4. Run Local Checks After First Launch

Owner: Codex or user

Reason: after Emacs and packages exist, the config can be loaded in batch mode.

Run:

```sh
make doctor
make check
```

Expected result: `make doctor` exits successfully or only reports intentional optional gaps, and `make check` loads `init.el` without errors.

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
