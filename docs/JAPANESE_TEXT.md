# Japanese Text

このプロジェクトは日本語ドキュメントを含むため、GUI Emacs では UTF-8 と日本語フォントの両方が必要です。

## Current State

`locale` と Emacs の coding system は UTF-8 でした。

日本語フォントも導入済みで、次のコマンドから Noto CJK フォントを確認できます。

```sh
fc-list :lang=ja family | head
```

新しい環境でこの結果が空の場合、Emacs 側で UTF-8 を正しく読めても、日本語
glyph を描画するフォントがなく、文字化けや豆腐表示に見えることがあります。

## Install Japanese Fonts When Missing

WSL 側で実行します。

```sh
sudo apt update
sudo apt install fonts-noto-cjk
```

確認:

```sh
fc-list :lang=ja family | head
bash scripts/doctor.sh
```

## Emacs Check

GUI Emacs 内で `M-:` を実行し、次を評価します。

```elisp
window-system
```

`x` が出れば、WSLg 経由の GUI Emacs です。

次に `M-x ec-describe-i18n` を実行します。

期待値:

- `language=Japanese`
- `locale=utf-8-unix`
- `japanese-font=Noto Sans CJK JP` など

`japanese-font=missing` の場合は、WSL 側に日本語フォントが見えていません。

## What The Config Does

[lisp/ec-i18n.el](../lisp/ec-i18n.el) で次を設定しています。

- Japanese language environment
- UTF-8 coding systems
- UTF-8 file names
- UTF-8 clipboard/selection
- Japanese font fallback, when a Japanese font is installed
- `半角/全角` で Emacs の日本語入力を切り替える
- 左の `無変換` で、未確定文字列をカタカナにする。未入力時は英数字入力にする
- 右の `変換` で日本語入力にする

フォント自体のインストールは OS 依存なので、この repo からは自動実行しません。

## Japanese Input

Emacs では標準の日本語入力方式を使います。

- `半角/全角`: 日本語入力と英数字入力を切り替える
- `無変換`: 未確定の入力全体をカタカナ化する。漢字変換中でも使用可能。
  未入力時は英数字入力にする。連打してもひらがなには戻らない
- `変換`: 日本語入力にする
- `C-\`: `半角/全角` と同じ切り替え操作
- 日本語入力中の `Space`: 漢字変換
- 漢字変換中の `←` / `→`: 現在の文節を縮める / 伸ばす
- 漢字変換中の `↑` / `↓`: 前 / 次の変換候補
- 漢字変換中の `C-f`: 現在の文節を確定して次の文節へ進む
- 日本語入力中の `Enter`: 確定

これは Windows IME の状態を読み取る設定ではありません。Windows と Emacs の
IME 状態は独立していますが、同じ物理キーを同じ目的に割り当てています。

Emacs 標準の KKC は文節を左から順に確定する方式です。Windows IME のように
確定前の文節間を左右へ自由に往復することはできません。

キーが反応しない場合は `C-h k` の後に対象キーを押します。Emacs が
`<muhenkan>`、`<henkan>`、`<zenkaku-hankaku>` のいずれかとして認識して
いるか確認してください。
