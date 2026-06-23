# IDE Reuse Research

調査日: 2026-06-23 JST

目的は、Emacs を VS Code / IntelliJ 風にする既存の取り組みを確認し、この repo でどこまで自作し、どこを流用するかを決めることです。

## Conclusion

この repo では、フルスクラッチで IDE を作らない。

推奨方針:

1. Emacs built-in と成熟パッケージを部品として使う
2. Doom/Spacemacs/Centaur/Prelude は丸ごと採用せず、設計例として参照する
3. 自作するのは「IntelliJ 風 keymap」「tab/project/work-context の運用」「画面分割 policy」の薄い層に限定する

理由:

- LSP、Git、補完、検索、project tree、debugger は既に強い実装がある
- 既存 distro を丸ごと入れると、その distro の思想・更新・依存管理に乗ることになる
- この repo の主目的は「VS Code/IntelliJ の再実装」ではなく、WSL 上の自分の作業モデルを Elisp で制御すること

## Existing Emacs IDE Distributions

| Project | What it proves | Reuse decision |
| --- | --- | --- |
| [Doom Emacs](https://github.com/doomemacs/doomemacs) | modern editor 風 UI、module、LSP、popup manager、workspace、ripgrep search まで揃う | 丸ごと採用しない。module 分割、doctor、popup/display policy は参考にする |
| [Spacemacs](https://github.com/syl20bnr/spacemacs) | layer 方式、leader key、Emacs/Vim hybrid、豊富な既成 package 構成 | 丸ごと採用しない。layer 方式と mnemonic key の考え方だけ参考 |
| [Centaur Emacs](https://github.com/seagle0128/.emacs.d) | GUI heavy な IDE 風 Emacs。LSP client 切替、dashboard、icons、hydra、debug まで含む | 丸ごと採用しない。UI/IDE package の候補一覧として参照 |
| [Prelude](https://github.com/bbatsov/prelude) | 標準 Emacs に近い、比較的控えめな distribution | 方針は近いが、この repo は既に小さく始めているので直接採用しない |

判断:

Doom/Spacemacs/Centaur は「Emacs を IDE 的に整える需要が既にある」ことの強い証拠です。ただし、どれも設定 framework そのものを受け入れる必要があります。この repo では、設定をプロジェクトとして理解し続けたいので、丸ごと移植ではなく必要部品の採用に留めます。

## Existing IDE Building Blocks

| Area | Existing option | Reuse decision |
| --- | --- | --- |
| LSP minimal core | [Eglot](https://www.gnu.org/software/emacs/manual/html_mono/eglot.html) | 採用済み。Emacs 標準統合を優先 |
| LSP full IDE UI | [lsp-mode](https://github.com/emacs-lsp/lsp-mode), [lsp-ui](https://github.com/emacs-lsp/lsp-ui) | 今は採用しない。Eglot で不足が明確になったら比較 |
| Debugger | [dap-mode](https://github.com/emacs-lsp/dap-mode) | 後で検証。Go/TS debug が必要になるまで保留 |
| Project tree | [Treemacs](https://github.com/Alexander-Miller/treemacs) | 後で採用候補。左ペインの project explorer が必要になったら入れる |
| Git | [Magit](https://github.com/magit/magit) | 採用済み。自作しない |
| Search/navigation | [Consult](https://github.com/minad/consult), [Vertico](https://github.com/minad/vertico), [Orderless](https://github.com/oantolin/orderless), [Embark](https://github.com/oantolin/embark) | 採用済み。Search Everywhere 相当の核にする |
| In-buffer completion | [Corfu](https://github.com/minad/corfu) | 採用済み。CAPF/Eglot と組み合わせる |
| Workspace isolation | built-in [tab-bar](https://www.gnu.org/software/emacs/manual/html_node/emacs/Tab-Bars.html), [tabspaces](https://github.com/mclear-tools/tabspaces), [perspective.el](https://github.com/nex3/perspective-el) | まず built-in tab-bar。buffer isolation が必要になったら tabspaces/perspective を比較 |
| Window undo/move | built-in [winner-mode/windmove](https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Convenience.html), [ace-window](https://github.com/abo-abo/ace-window) | winner は採用済み。ace-window は分割が増えたら検討 |

## VS Code / IntelliJ Similarity

直接「Emacs を IntelliJ 化する」定番パッケージは、Doom や Spacemacs ほどの標準候補としては見当たりませんでした。

一方で、逆方向の需要は確認できます。

- VS Code には [IntelliJ IDEA Keybindings](https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings) があり、Search Everywhere、Go to Declaration、Find Usages、Navigate Back/Forward などを VS Code に移植している
- VS Code には [Emacs Keymap](https://marketplace.visualstudio.com/items?itemName=hiro-sun.vscode-emacs) もあり、C-f/C-b/C-n/C-p/M-x などを VS Code 側に寄せる需要がある
- IntelliJ IDEA は keymap を複製・編集できる設計を公式に持っている

ここからの判断:

キーマップは巨大 framework を探すより、この repo で薄く作る方がよい。IntelliJ 操作を Emacs command に対応させるだけなら、`xref`, `project.el`, `consult`, `eglot`, `magit` の wrapper で十分です。

## What To Reuse

自作しないもの:

- LSP protocol client
- Go/TypeScript language server integration
- Git porcelain
- fuzzy/search UI
- completion UI
- project tree rendering
- debug adapter protocol
- terminal emulator
- package manager

既に採用済み:

- `eglot`
- `project.el`
- `xref`
- `flymake`
- `eldoc`
- `tab-bar`
- `winner-mode`
- `vertico`
- `orderless`
- `marginalia`
- `consult`
- `embark`
- `corfu`
- `magit`

短期で追加候補:

- `treemacs`: 左ペイン project explorer が必要になった時
- `tabspaces`: tab ごとの buffer list 分離が必要になった時
- `ace-window`: window 数が増えて移動が面倒になった時

中期で追加候補:

- `dap-mode`: Go/TypeScript debug を Emacs 内で行う必要が出た時
- `lsp-mode` / `lsp-ui`: Eglot では足りない IDE UI が明確になった時

## What To Build Ourselves

この repo で自作すべきもの:

### 1. IntelliJ-like command layer

例:

- `go to definition` -> `xref-find-definitions`
- `go to implementation` -> `eglot-find-implementation`
- `find usages` -> `xref-find-references`
- `recent files / buffers` -> `consult-buffer`
- `search everywhere` -> custom command combining buffers, files, symbols, commands
- `project search` -> `consult-ripgrep`
- `rename` -> `eglot-rename`

これは package ではなく、この repo の `ec-keymap.el` として持つのが正しいです。

### 2. Work context model

この repo の作業モデル:

- `tab` = 作業文脈
- `project` = Git root / WSL repo
- `buffer` = file, shell, Magit, diagnostics, AI terminal
- `window` = pane
- `frame` = Windows desktop 上の GUI Emacs window

ここは既存 distro を入れるより、自分の作業方法に合わせて小さく育てるべきです。

### 3. Display policy

例:

- diagnostics/xref/search は下
- help/eldoc/action は右
- shell/AI shell は下
- Magit は必要に応じて same-window または専用 tab
- Treemacs を入れるなら左固定

Doom の popup manager 的な考え方は参考になりますが、実装は `display-buffer-alist` で十分に始められます。

### 4. Project bootstrap commands

将来的に作るとよい command:

- `ec-open-project-tab`
- `ec-project-layout-code`
- `ec-project-layout-code-shell`
- `ec-project-layout-code-git-shell`
- `ec-search-everywhere`
- `ec-toggle-left-project-tree`
- `ec-toggle-bottom-terminal`

ここがこの repo の独自価値になります。

## Recommended Roadmap

### Phase 1: Small Custom Config

Status: current repo

- Eglot + Go/TypeScript
- Consult/Vertico/Orderless
- Corfu
- Magit
- tab-bar
- minimal IntelliJ-like keymap

Goal: 定義ジャンプ、戻る、参照検索、project file search、ripgrep、Git status が安定すること。

### Phase 2: Layout Experiment

Add only if needed:

- Treemacs for left project tree
- tabspaces for project/work-context buffer isolation
- ace-window for fast pane selection

Goal: VS Code/IntelliJ の tool window 的な配置を、自分の tab/window/buffer model で再現する。

### Phase 3: IDE Features

Add only when daily workflow needs it:

- dap-mode
- test runner commands
- format/import commands
- DB client integration
- AI terminal/chat layout

Goal: 本当に使う機能だけ IDE 化する。

### Phase 4: Distribution Discipline

Borrow from Doom/Spacemacs:

- `doctor` command/script
- module boundary
- optional features behind feature flags
- reproducible package versions if config churn becomes painful

Goal: 設定 repo 自体を保守可能にする。

## Decision Record

| Decision | Status | Rationale |
| --- | --- | --- |
| Adopt Doom Emacs wholesale | Rejected for now | Too much framework for the current goal |
| Adopt Spacemacs wholesale | Rejected for now | Leader/layer design is useful, but Evil-centric assumptions are not needed |
| Adopt Centaur wholesale | Rejected for now | Strong IDE config, but too broad and opinionated |
| Stay close to vanilla Emacs | Accepted | Keeps the config understandable and hackable |
| Use Eglot first | Accepted | Built-in, integrates with Xref/Flymake/Eldoc/Imenu |
| Use lsp-mode first | Deferred | More IDE-like, but heavier and more moving parts |
| Build IntelliJ keymap ourselves | Accepted | Thin mapping layer; no need for a distro |
| Build Git UI ourselves | Rejected | Magit already solves this well |
| Build project tree ourselves | Rejected | Treemacs exists |
| Build workspace isolation ourselves | Deferred | Start with tab-bar; use tabspaces/perspective if needed |

## Sources

- [Doom Emacs README](https://github.com/doomemacs/doomemacs)
- [Spacemacs README](https://github.com/syl20bnr/spacemacs)
- [Centaur Emacs README](https://github.com/seagle0128/.emacs.d)
- [Prelude README](https://github.com/bbatsov/prelude)
- [GNU Eglot Manual](https://www.gnu.org/software/emacs/manual/html_mono/eglot.html)
- [GNU Emacs Tab Bars Manual](https://www.gnu.org/software/emacs/manual/html_node/emacs/Tab-Bars.html)
- [GNU Emacs Window Convenience Manual](https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Convenience.html)
- [lsp-mode README](https://github.com/emacs-lsp/lsp-mode)
- [lsp-ui README](https://github.com/emacs-lsp/lsp-ui)
- [dap-mode README](https://github.com/emacs-lsp/dap-mode)
- [Treemacs README](https://github.com/Alexander-Miller/treemacs)
- [Magit README](https://github.com/magit/magit)
- [Consult README](https://github.com/minad/consult)
- [Vertico README](https://github.com/minad/vertico)
- [Orderless README](https://github.com/oantolin/orderless)
- [Embark README](https://github.com/oantolin/embark)
- [Corfu README](https://github.com/minad/corfu)
- [tabspaces README](https://github.com/mclear-tools/tabspaces)
- [Perspective README](https://github.com/nex3/perspective-el)
- [ace-window README](https://github.com/abo-abo/ace-window)
- [IntelliJ IDEA Keybindings for VS Code](https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings)
- [Emacs Keymap for VS Code](https://marketplace.visualstudio.com/items?itemName=hiro-sun.vscode-emacs)
- [IntelliJ IDEA Keymap documentation](https://www.jetbrains.com/help/idea/settings-keymap.html)
