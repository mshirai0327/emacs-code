# GUI Target

このプロジェクトのゴールは、terminal/CLI Emacs ではなく GUI Emacs です。

目指す体験:

- Windows デスクトップ上に GUI アプリとして Emacs を表示する
- WSL 内の repo / Git / Go / Node / language server をそのまま使う
- VS Code / IntelliJ のように、左 Project/Git tool area、中央 editor、下 terminal を構成できるようにする
- Project/Git tool area は設定または command で左右へ移動できるようにする
- キーボード中心で Search Everywhere、Go to Definition、Find Usages、Git、terminal、tab/work-context を操作する
- IntelliJ の `Ctrl+N` のように、workspace symbol を中央の floating window から検索する

## Why Commands Still Appear

セットアップ手順に CLI コマンドが出てくるのは、WSL 側へ GUI Emacs と language server を入れるためです。

実際に日常利用する対象は `emacs -nw` のような terminal Emacs ではありません。

想定起動:

```sh
emacs &
```

`emacs-gtk` が入っていて WSLg が有効なら、これは Windows 側に GUI Emacs window を表示します。

避けたい起動:

```sh
emacs -nw
```

`-nw` は no window、つまり terminal 内 Emacs です。このプロジェクトの主対象ではありません。

## Why WSL GUI Emacs First

Windows native Emacs ではなく WSL 側 GUI Emacs を最初に使う理由:

- 開発 repo が WSL filesystem にある
- Node/typescript-language-server と Go/gopls も WSL 側にある
- Git や shell も WSL 側で完結する
- Windows native Emacs から WSL repo を触ると path/toolchain/LSP の境界が複雑になる

つまり、実行場所は WSL、表示は Windows GUI です。

## Current State

現在の repo は GUI-first の骨格です。

できているもの:

- WSLg 上での GUI Emacs 起動
- LSP/search/Git/completion/tab の基礎設定
- IntelliJ 風 keymap の入口
- Treemacs による左 project tree の入口
- tab-line による VS Code 風 file tab の入口
- display-buffer による下/右 panel の初期 policy

まだ不足しているもの:

- `embodied-reflecta` 系 project での TypeScript/Eglot workflow 確認
- VS Code に近い theme
- IntelliJ 風の floating Navigate popup
- 下部 terminal panel の完成度
- 左右へ移動可能な Project/Git tool area
- project tab ごとの layout bootstrap command
- Windows shortcut からの WSL GUI Emacs 起動
- GUI screenshot / user journey docs

具体的な実装順は [ROADMAP.md](ROADMAP.md) で管理します。
