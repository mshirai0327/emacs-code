
# emacs-code

## Goal of This Project

VSCode のようなUI/操作性でEmacsを使いたい
できるだけキーボード操作のみでIDEを操作したいと思った。Intellij のように。そんなモダンなIDEをEmacsのエコシステムとAIの力(エディタのためにELispを学び初めるのは実際問題辛い)でどこまで近付けるか。そんな挑戦。
Emacs使いにはきっと邪道な挑戦であろうが、Emacs からVScodeなどに乗り移る人（私もかつてそうであった）を数多く見た上で、Emacsを理解し、VScode前提ともいえる現場の主要開発スタイルにどこまで適合できるかを確かめたいと思った。

今さらEmacs、今こそEmacs

## 概要

WSL 上の Go/TypeScript 開発を前提にした個人用 Emacs 設定プロジェクトです。

狙いは VS Code や IntelliJ を完全に複製することではなく、次の作業モデルを Emacs Lisp で育てられる状態にすることです。

- terminal/CLI Emacs ではなく、GUI Emacs を主対象にする
- WSL 内の repo / Git / Go / Node toolchain をそのまま使う
- Windows 側には WSLg の GUI Emacs を出す
- IntelliJ 風の「検索・移動・戻る」をキーボード中心で使う
- tab-bar をプロジェクトや作業文脈の切り替えに使う
- ユーザー個別の OS 設定や既存 `~/.config/emacs` は勝手に変更しない

## Quick Start

まず不足している依存を確認します。

```sh
bash scripts/doctor.sh
```

このリポジトリを Emacs 設定として使う場合は、既存設定がないことを確認してからリンクします。

```sh
bash scripts/link-config.sh
```

既存の `~/.config/emacs` がある場合、スクリプトは停止します。退避してよい場合だけ次を使います。

```sh
bash scripts/link-config.sh --backup
```

Emacs を起動します。

```sh
emacs &
```

最初の起動時は MELPA / GNU ELPA からパッケージを取得します。

## User-Dependent Setup

次の作業はユーザー環境に依存するため、このリポジトリからは自動実行しません。

- `sudo apt install` など OS パッケージの導入
- `npm install -g` の global prefix 方針
- 既存 `~/.config/emacs` の退避や統合
- Windows native Emacs との併用
- SSH/GPG/Git credential の設定

残タスクの状態管理は [docs/USER_TASKS.md](docs/USER_TASKS.md)、WSL 向けの具体手順は [docs/SETUP_WSL.md](docs/SETUP_WSL.md) を見てください。

## What Is Included

- `early-init.el`: 起動前の軽量化と GUI 初期値
- `init.el`: モジュール読み込みだけを行う入口
- `lisp/ec-core.el`: package archive、custom file、基本変数
- `lisp/ec-ui.el`: 見た目、行番号、which-key
- `lisp/ec-completion.el`: vertico / orderless / marginalia / consult / corfu
- `lisp/ec-navigation.el`: project.el / xref / ripgrep
- `lisp/ec-prog.el`: eglot、Go、TypeScript/TSX
- `lisp/ec-layout.el`: tab-bar、winner-mode、補助 buffer の表示位置
- `lisp/ec-keymap.el`: IntelliJ 風の移動・検索キー
- `lisp/ec-terminal.el`: project root で開く shell/eshell

GUI として目指す体験は [docs/GUI_TARGET.md](docs/GUI_TARGET.md) にあります。
設計メモは [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)、キー一覧は [docs/KEYMAP.md](docs/KEYMAP.md) にあります。
既存の Emacs IDE 化事例と、この repo での流用/自作方針は [docs/IDE_REUSE_RESEARCH.md](docs/IDE_REUSE_RESEARCH.md) にまとめています。
日本語表示の前提と確認方法は [docs/JAPANESE_TEXT.md](docs/JAPANESE_TEXT.md) にあります。

## Local Verification

Emacs を一度起動して必要パッケージを取得した後は、パッケージ自動取得を止めた状態で設定が読めるか確認できます。

```sh
EC_NO_PACKAGE_INSTALL=1 emacs --batch -l init.el
```

Make が使える場合は次でも同じです。

```sh
make doctor
make check
```
