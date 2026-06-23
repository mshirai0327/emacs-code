# Keymap

Windows/WSLg では Super キー、つまり Emacs の `s-` が OS に捕まることがあります。そのため、すべての主要操作に `C-c i` prefix を用意しています。

## Navigation

| Action | Reliable key | Optional Super key |
| --- | --- | --- |
| Go to definition | `C-c i d` | `s-b` |
| Find references | `C-c i u` | `s-u` |
| Rename symbol | `C-c i r` | `s-r` |
| Back | `C-c i [` | `s-[` |
| Forward | `C-c i ]` | `s-]` |

## Search

| Action | Reliable key | Optional Super key |
| --- | --- | --- |
| Find file in project | `C-c i f` | `s-o` |
| Search text in project | `C-c i s` | `s-f` |
| Switch buffer / recent buffer | `C-c i e` | `s-e` |
| Imenu symbols in buffer | `C-c i m` | `s-m` |
| Switch project | `C-c i p` | `s-p` |

## Tools

| Action | Reliable key | Optional Super key |
| --- | --- | --- |
| Magit status | `C-c i g` | `s-g` |
| New tab | `C-c i t n` | `s-t` |
| Close tab | `C-c i t k` | `s-w` |
| Rename tab to project | `C-c i t r` | none |
| Project shell | `C-c i !` | none |
| Project eshell | `C-c i ;` | none |

## Notes

Emacs 標準の `M-.` と `M-,` も xref の定義ジャンプ/戻るとして使えます。この repo では IntelliJ 風の入口を足すだけで、Emacs 標準キーはなるべく壊しません。
