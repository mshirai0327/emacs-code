# Architecture

## Working Model

この repo は Emacs 本体改造ではなく、GUI-first な個人用 Emacs distribution として育てます。terminal/CLI Emacs は主対象ではありません。

基本モデル:

- frame: Windows デスクトップ上に出る Emacs GUI ウィンドウ
- window: Emacs 内の分割ペイン
- buffer: ファイル、shell、Git、help、diagnostics などの内容
- tab: project や investigation などの作業文脈
- project: `project.el` が認識する Git root など

VS Code の workspace に作業モデルを合わせるのではなく、Emacs の tab/window/buffer/project を組み合わせて自分の作業単位を作る方針です。

## Module Layout

`init.el` は入口に限定し、実体は `lisp/` に分けます。

- `ec-core.el`: package archive、`use-package`、`custom-file`、PATH の土台
- `ec-ui.el`: GUI の見た目、行番号、which-key
- `ec-completion.el`: minibuffer と補完 UI
- `ec-navigation.el`: project/xref/ripgrep
- `ec-prog.el`: eglot、言語 mode、language server 対応
- `ec-layout.el`: tab-bar、winner-mode、補助 buffer の配置
- `ec-keymap.el`: IntelliJ 風 keymap
- `ec-terminal.el`: project root で開く shell/eshell

## Package Policy

初回起動時に Emacs package manager で必要パッケージを取得します。

対象:

- `vertico`
- `orderless`
- `marginalia`
- `consult`
- `embark`
- `corfu`
- `magit`
- `which-key`
- `go-mode`
- `markdown-mode`
- `yaml-mode`

`eglot`, `project`, `xref`, `tab-bar`, `winner`, `eshell` は Emacs built-in として扱います。

一度パッケージを取得した後、自動取得を止めて読み込み確認したい場合:

```sh
EC_NO_PACKAGE_INSTALL=1 emacs --batch -l init.el
```

## Configuration Boundaries

この repo が管理するもの:

- Emacs Lisp 設定
- キーバインド
- WSL 前提の PATH 補助
- 導入手順
- 診断スクリプト

この repo が直接管理しないもの:

- OS package install
- npm global install 方針
- 既存 `~/.config/emacs` の統合判断
- Git credential / SSH key / GPG
- Windows native Emacs 固有設定

## Growth Plan

最初の優先順位:

1. `embodied-reflecta` 系 project で TypeScript/Eglot workflow を検証する
2. VS Code に近い theme を整える
3. Eglot/xref と Consult を使った IntelliJ 風 Navigate popup を作る
4. 下 terminal と移動可能な左 Project/Git tool area を構築する
5. Windows shortcut から WSL GUI Emacs を起動する
6. tab-bar で複数 project/work context を切り替える
7. 必要になったものだけ Elisp で小さく拡張する

DB UI は IntelliJ/DataGrip の方が強い領域なので、最初から完全再現しません。必要になった時点で `sql-mode` や外部 CLI 連携を追加します。

既存の Emacs IDE 化事例と流用判断は [IDE_REUSE_RESEARCH.md](IDE_REUSE_RESEARCH.md) を参照します。
具体的な実装順と完了条件は [ROADMAP.md](ROADMAP.md) を参照します。
