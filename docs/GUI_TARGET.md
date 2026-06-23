# GUI Target

このプロジェクトのゴールは、terminal/CLI Emacs ではなく GUI Emacs です。

目指す体験:

- Windows デスクトップ上に GUI アプリとして Emacs を表示する
- WSL 内の repo / Git / Go / Node / language server をそのまま使う
- VS Code / IntelliJ のように、左 project tree、中央 editor、下 terminal、右 auxiliary panel を構成できるようにする
- キーボード中心で Search Everywhere、Go to Definition、Find Usages、Git、terminal、tab/work-context を操作する

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
- Go/Node/gopls/typescript-language-server も WSL 側にある
- Git や shell も WSL 側で完結する
- Windows native Emacs から WSL repo を触ると path/toolchain/LSP の境界が複雑になる

つまり、実行場所は WSL、表示は Windows GUI です。

## Current State

現在の repo は GUI-first の骨格です。

できているもの:

- GUI Emacs 起動前提の setup docs
- LSP/search/Git/completion/tab の基礎設定
- IntelliJ 風 keymap の入口
- display-buffer による下/右 panel の初期 policy

まだ不足しているもの:

- VS Code の Explorer 相当の左 project tree
- 下部 terminal panel の完成度
- 右側 auxiliary panel の具体機能
- project tab ごとの layout bootstrap command
- GUI screenshot / user journey docs

短期的には、Treemacs と layout command を追加して「見た目にも VS Code/IntelliJ 的」と分かる状態に進めます。
