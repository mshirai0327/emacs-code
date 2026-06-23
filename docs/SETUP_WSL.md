# WSL Setup

この構成は、terminal/CLI Emacs ではなく GUI Emacs を使う前提です。Windows 上で WSL2 repo を使い、GUI は WSLg で Emacs を表示します。

## 1. Check Current State

```sh
bash scripts/doctor.sh
```

実際の状態は `doctor.sh` の結果を優先してください。現在のユーザー依存タスクは [USER_TASKS.md](USER_TASKS.md) で管理します。

## 2. Install OS Packages

Ubuntu/Debian 系 WSL の例です。`sudo` が必要なので手動で実行してください。

```sh
sudo apt update
sudo apt install emacs-gtk git ripgrep fd-find
```

`fd-find` は distro によって `fdfind` という名前で入ります。この設定では `fd` がなくても `fdfind` を検出できます。

## 3. Install Language Servers

Go:

```sh
go install golang.org/x/tools/gopls@latest
```

`gopls` は通常 `$HOME/go/bin` に入ります。この設定はそのパスを Emacs の `exec-path` に追加します。

TypeScript/JavaScript:

```sh
npm install -g typescript typescript-language-server
```

global install を避けたい場合は、チームや個人の Node 管理方針に合わせてください。その場合、Emacs から `typescript-language-server` が見えるように PATH を調整します。

## 4. Link This Repo As Emacs Config

既存設定がない場合:

```sh
bash scripts/link-config.sh
```

既存設定を退避して切り替える場合:

```sh
bash scripts/link-config.sh --backup
```

このスクリプトは `~/.config/emacs` をこの repo への symlink にします。既存設定がある場合は、明示的に `--backup` を付けない限り停止します。

## 5. Start GUI Emacs

```sh
emacs &
```

WSLg が有効なら Windows 側に GUI ウィンドウが出ます。
`emacs -nw` は terminal 内 Emacs なので、このプロジェクトの主対象ではありません。

## 6. First Project Check

Go repo:

1. Go ファイルを開く
2. `M-x eglot`
3. `C-c i d` で定義ジャンプ
4. `C-c i [` で戻る

TypeScript repo:

1. `ts` または `tsx` ファイルを開く
2. `M-x eglot`
3. `C-c i d` で定義ジャンプ
4. `C-c i s` で project ripgrep

安定してから `eglot-ensure` の自動起動を増やす方針です。現在の設定では Go/TypeScript/TSX/JS 系 major mode で自動起動します。

## Troubleshooting

`emacs: command not found`

`emacs-gtk` または distro に合う GUI Emacs パッケージを入れてください。

`gopls: command not found`

`go install golang.org/x/tools/gopls@latest` の後、shell 側でも `$HOME/go/bin` が PATH に入っているか確認します。Emacs 側にはこの repo の設定で追加しています。

`typescript-language-server: command not found`

`npm install -g typescript typescript-language-server` を実行するか、npm global bin を PATH に追加してください。

Super/Windows キーのショートカットが効かない

Windows や WSLg が `s-` 系キーを横取りする場合があります。必ず `C-c i` prefix の代替キーも使えるようにしています。
