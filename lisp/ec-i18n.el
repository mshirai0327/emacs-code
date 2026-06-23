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

(defun ec-quail-katakana-all ()
  "Convert the entire active Quail composition to Katakana."
  (interactive)
  (setq quail-translating nil)
  (let ((start (overlay-start quail-conv-overlay))
        (end (overlay-end quail-conv-overlay)))
    (japanese-katakana-region start end)
    (setq quail-conversion-str
          (buffer-substring start end))))

(defun ec-kkc-katakana-all ()
  "Convert the entire active KKC composition to Katakana."
  (interactive)
  (let ((length (length kkc-current-key)))
    (setq kkc-length-head length
          kkc-length-converted length)
    (setcar kkc-current-conversions -1)
    (kkc-update-conversion 'all)))

(defun ec-configure-japanese-input-keys ()
  "Configure keys used while Japanese text is still being composed."
  (let ((map (nth 5 (quail-package "japanese"))))
    (dolist (key '("<muhenkan>" "<non-convert>"))
      (define-key map (kbd key) #'ec-quail-katakana-all))))

(defun ec-configure-kana-kanji-conversion-keys ()
  "Configure arrow keys used during Kana-Kanji conversion."
  (define-key kkc-keymap (kbd "<left>") #'kkc-shorter)
  (define-key kkc-keymap (kbd "<right>") #'kkc-longer)
  (define-key kkc-keymap (kbd "<up>") #'kkc-prev)
  (define-key kkc-keymap (kbd "<down>") #'kkc-next)
  (dolist (key '("<muhenkan>" "<non-convert>"))
    (define-key kkc-keymap (kbd key) #'ec-kkc-katakana-all)))

;; Match the user's Windows IME key layout inside Emacs.  These control
;; Emacs' own input method; Windows and Emacs do not share IME state.
(global-set-key (kbd "<zenkaku-hankaku>") #'toggle-input-method)
(dolist (key '("<muhenkan>" "<non-convert>"))
  (global-set-key (kbd key) #'ec-disable-input-method))
(dolist (key '("<henkan>" "<henkan-mode>" "<convert>"))
  (global-set-key (kbd key) #'ec-enable-japanese-input))

;; `quail/japanese' has no feature to `require', so configure its transient
;; translation keymap after the input method file is loaded on first use.
(with-eval-after-load "quail/japanese"
  (ec-configure-japanese-input-keys))

(with-eval-after-load 'kkc
  (ec-configure-kana-kanji-conversion-keys))

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
