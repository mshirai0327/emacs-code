# Roadmap

WSL の初期セットアップは完了しました。これからは「起動できる Emacs」から
「日常的に使える VS Code 風 IDE」へ進めます。

優先順位は、TypeScript 開発機能の確認、見た目、Navigate popup、画面構成、
Windows からの起動、複数リポジトリ対応の順です。一度に大きな IDE framework
を導入せず、`embodied-reflecta` など実際に日常利用する project で問題点を
確認します。

## Target UI

```text
+----------------------+--------------------------------+
| Project / Git        |                                |
| tool area            | Editor                         |
|                      |                                |
+----------------------+--------------------------------+
| Terminal                                              |
+-------------------------------------------------------+
```

- 中央: コード編集
- 下: project root で動く terminal
- 左: project 構成と Git を切り替えて表示する tool area
- 上: project/work context を切り替える tab-bar

Project と Git は同じ tool area を切り替えて使う方式から始めます。
tool area の side は設定値にし、左を既定値としながら右へ移動できるようにします。
将来は実行中に左右を切り替える command も追加します。

## Phase 0: Validate TypeScript Development

Status: next

私生活で主に使う言語は TypeScript です。
`typescript-language-server 5.3.0` と Eglot の設定はあるため、
`embodied-reflecta` または `embodied-reflecta-gpt` を使って実用確認します。

Tasks:

- TypeScript/TSX file を開いたときに Eglot と
  `typescript-language-server` が自動起動するか確認する
- 定義ジャンプ、戻る、参照検索、rename を確認する
- diagnostics と format/import の挙動を確認する
- project file search と ripgrep が repository root を正しく使うか確認する
- 問題があれば PATH、project root、Eglot event log を調査する

Done when:

- `embodied-reflecta` 系 project で `C-c i d`、`C-c i [`、
  `C-c i u`、`C-c i r` が使える
- 保存または明示コマンドで format/import を安定して実行できる

Go support は削除しません。`gopls v0.22.0` は導入済みですが、私生活で実際に
使う Go project がないため、実用確認は仕事上必要になった時点まで deferred
とします。

## Phase 1: VS Code-Like Colors

Status: initial implementation added

`vscode-dark-plus-theme` を導入し、mode-line、tab-bar、tab-line、
minibuffer、Treemacs などの基本 UI face を `ec-ui.el` で調整しています。
実 project で TypeScript/TSX、Markdown、日本語、diagnostics、Git diff の
見え方を確認しながら追加調整します。

最初に色だけを変え、レイアウト変更と混ぜません。

Tasks:

- VS Code Dark+ に近い theme 候補を比較する
- editor、mode-line、tab-bar、minibuffer、completion、Magit の色を確認する
- TypeScript/TSX、Markdown、日本語の可読性を確認する
- theme 固有の調整は `ec-ui.el` に限定する

Done when:

- 起動直後から一貫した dark theme が適用される
- 選択範囲、検索結果、diagnostics、Git diff が見分けやすい
- terminal と editor の背景色が不自然に分断されない

## Phase 2: IntelliJ-Like Navigate Popup

Status: planned

IntelliJ の `Ctrl+N` に近い、中央に浮く検索 UI を作ります。
TypeScript では Eglot/xref を使い、language server の workspace symbol を
検索対象にできます。

Tasks:

- `xref-find-apropos` を使った workspace symbol 検索 command を作る
- project file、開いている buffer、workspace symbol の役割を整理する
- Consult/Vertico で絞り込み、preview、決定後のジャンプを確認する
- `vertico-posframe` などの child-frame frontend で画面中央へ表示する
- Eglot 未接続時には project file search などへ安全に fallback する
- 検索対象が class、function、variable など何か分かる表示を検討する

Key policy:

- 最初は `C-c i n` を確実な入口にする
- `C-n` は Emacs 標準の「次の行」と競合するため、上書きを設定で選択可能にする
- IntelliJ 操作を優先する設定では `C-n` を Navigate popup に割り当てる

Done when:

- `embodied-reflecta` 系 project の TypeScript symbol を名前で検索できる
- 入力中に候補が絞られ、選択すると定義位置へ移動する
- GUI では editor 中央の floating window として表示される
- floating window が使えない環境では通常の minibuffer UI に fallback する

## Phase 3: IDE Layout

Status: planned

画面構成を一度に再現できる project layout command を作ります。
Treemacs による左 project tree の初期入口は `C-c i x` で追加済みです。
この phase では、terminal、Git、tool area 切り替えまで含めた標準レイアウト
として仕上げます。

Tasks:

- 下部 terminal panel を安定させる
- 左側 project tree を標準レイアウトへ組み込む
- tool area で project tree と Magit status を切り替えられるようにする
- tool area の side を左または右へ変更できる設定と command を作る
- editor を開いても side window が意図せず消えないようにする
- panel の表示・非表示と focus 移動をキーボードで操作できるようにする
- project tab を開くと標準レイアウトを構築する command を作る

Initial package policy:

- project tree は Treemacs を第一候補にする
- Git は既存の Magit を使い、自作しない
- terminal はまず shell/eshell を使い、必要なら `vterm` または `eat` を検討する
- 配置制御は既存の `display-buffer-alist` と専用 command で行う

Done when:

- 1 command で editor、下 terminal、左 tool area が開く
- panel を閉じても同じ command で復元できる
- Project/Git tool area を左右へ移動できる
- project tree、Git、terminal、editor 間をキーボードだけで移動できる

## Phase 4: Launch From Windows

Status: planned

ここでいう「Windows 側で起動」は、Windows native Emacs へ移行することでは
ありません。Windows のショートカットから WSL 上の GUI Emacs を起動します。
repo、Git、Go、Node、language server は引き続き WSL 側を使います。

Tasks:

- `emacsclient` を使って既存 Emacs server へ新しい GUI frame を開く
- server がない場合だけ自動起動する WSL launcher script を作る
- Windows Terminal を経由せず起動できる PowerShell または shortcut を用意する
- Windows のスタートメニューまたはタスクバーから起動できるようにする
- Windows から渡された WSL path/project を開けるようにする

想定する入口:

```text
Windows shortcut
  -> wsl.exe
  -> WSL launcher script
  -> emacsclient
  -> WSLg GUI frame
```

Windows native Emacs は、WSL filesystem、Git、LSP、PATH の境界が増えるため
当面は採用しません。

Done when:

- Windows のアイコンから Emacs を起動できる
- 2回目以降は既存 server を再利用し、短時間で frame が開く
- Windows Terminal を手動で開いて `emacs &` を入力する必要がない

## Phase 5: Multiple Repositories

Status: planned

Tasks:

- 1 project を 1 tab/work context として扱う
- project ごとに editor、terminal、project tree、Git の対象 root を揃える
- project 切り替え時に無関係な buffer が混ざりにくくする
- recent project と複数 repo の切り替え command を整える
- 必要なら tabspaces を検討する

Done when:

- 複数 repo を開いても terminal と Magit が別 project を誤参照しない
- project 切り替え後に標準レイアウトをすぐ復元できる

## Working Order

直近は次の順で進めます。

1. `embodied-reflecta` 系 project で TypeScript/Eglot を確認する
2. VS Code に近い色を選び、`ec-ui.el` へ実装する
3. IntelliJ 風の Navigate popup を作る
4. 下 terminal と左 Project/Git tool area を作る
5. Windows launcher を作る
6. 複数 repo/tab の分離を強化する

各 phase の実装後に `make check` を実行し、GUI でも手動確認してから
コミットします。
