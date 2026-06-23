;;; ec-i18n.el --- Japanese and UTF-8 settings -*- lexical-binding: t; -*-

(require 'seq)

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(setq locale-coding-system 'utf-8-unix)
(setq selection-coding-system 'utf-8-unix)
(setq file-name-coding-system 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8-unix)

(defun ec-enable-japanese-input ()
  "Enable Emacs' built-in Japanese input method."
  (interactive)
  (unless (equal current-input-method "japanese")
    (activate-input-method "japanese")))

(defun ec-disable-input-method ()
  "Switch explicitly to direct Latin input."
  (interactive)
  (when current-input-method
    (deactivate-input-method)))

(defun ec-configure-japanese-input-keys ()
  "Configure keys used while Japanese text is still being composed."
  (define-key quail-translation-keymap
              (kbd "<muhenkan>")
              #'quail-japanese-toggle-kana))

;; Match the user's Windows IME key layout inside Emacs.  These control
;; Emacs' own input method; Windows and Emacs do not share IME state.
(global-set-key (kbd "<zenkaku-hankaku>") #'toggle-input-method)
(global-set-key (kbd "<muhenkan>") #'ec-disable-input-method)
(global-set-key (kbd "<henkan>") #'ec-enable-japanese-input)

;; `quail/japanese' has no feature to `require', so configure its transient
;; translation keymap after the input method file is loaded on first use.
(with-eval-after-load "quail/japanese"
  (ec-configure-japanese-input-keys))

(defconst ec-japanese-font-candidates
  '("Noto Sans CJK JP"
    "Noto Sans Mono CJK JP"
    "Noto Serif CJK JP"
    "IPAexGothic"
    "IPAGothic"
    "TakaoGothic"
    "Yu Gothic"
    "Meiryo")
  "Preferred Japanese font families.")

(defun ec-available-font-family (families)
  "Return the first available font family from FAMILIES."
  (seq-find (lambda (family)
              (member family (font-family-list)))
            families))

(defun ec-setup-japanese-font ()
  "Set a Japanese font fallback when a supported font is installed."
  (when (display-graphic-p)
    (when-let ((font (ec-available-font-family ec-japanese-font-candidates)))
      (set-fontset-font t 'japanese-jisx0208 font nil 'append)
      (set-fontset-font t 'japanese-jisx0212 font nil 'append)
      (set-fontset-font t 'katakana-jisx0201 font nil 'append)
      (set-fontset-font t '(#x3040 . #x30ff) font nil 'append)
      (set-fontset-font t '(#x4e00 . #x9fff) font nil 'append))))

(add-hook 'after-init-hook #'ec-setup-japanese-font)

(defun ec-describe-i18n ()
  "Show current coding and Japanese font status."
  (interactive)
  (message "language=%s locale=%s file=%s japanese-font=%s"
           current-language-environment
           locale-coding-system
           buffer-file-coding-system
           (or (ec-available-font-family ec-japanese-font-candidates)
               "missing")))

(provide 'ec-i18n)
;;; ec-i18n.el ends here
