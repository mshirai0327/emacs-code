;;; ec-keymap.el --- IntelliJ-like key entry points -*- lexical-binding: t; -*-

(defvar ec-intellij-map (make-sparse-keymap)
  "Prefix map for IntelliJ-like commands.")

(define-key global-map (kbd "C-c i") ec-intellij-map)

(defun ec-call-if-available (command fallback)
  "Call COMMAND when it is bound, otherwise call FALLBACK."
  (call-interactively (if (fboundp command) command fallback)))

(defun ec-find-implementation ()
  "Find implementation through Eglot when available."
  (interactive)
  (ec-call-if-available 'eglot-find-implementation 'xref-find-definitions))

(defun ec-rename-symbol ()
  "Rename symbol through Eglot when available."
  (interactive)
  (if (fboundp 'eglot-rename)
      (call-interactively #'eglot-rename)
    (user-error "eglot-rename is unavailable; start Eglot first")))

(define-key ec-intellij-map (kbd "d") #'xref-find-definitions)
(define-key ec-intellij-map (kbd "i") #'ec-find-implementation)
(define-key ec-intellij-map (kbd "u") #'xref-find-references)
(define-key ec-intellij-map (kbd "r") #'ec-rename-symbol)
(define-key ec-intellij-map (kbd "[") #'xref-go-back)
(define-key ec-intellij-map (kbd "]") #'xref-go-forward)

(define-key ec-intellij-map (kbd "f") #'project-find-file)
(define-key ec-intellij-map (kbd "s") #'consult-ripgrep)
(define-key ec-intellij-map (kbd "e") #'consult-buffer)
(define-key ec-intellij-map (kbd "m") #'consult-imenu)
(define-key ec-intellij-map (kbd "p") #'project-switch-project)

(define-key ec-intellij-map (kbd "g") #'magit-status)
(define-key ec-intellij-map (kbd "!") #'ec-shell)
(define-key ec-intellij-map (kbd ";") #'ec-eshell)

(define-prefix-command 'ec-tab-map)
(define-key ec-intellij-map (kbd "t") 'ec-tab-map)
(define-key ec-tab-map (kbd "n") #'tab-new)
(define-key ec-tab-map (kbd "k") #'tab-close)
(define-key ec-tab-map (kbd "r") #'ec-rename-tab-to-project)
(define-key ec-tab-map (kbd "p") #'ec-new-project-tab)

;; Optional Super bindings. Windows/WSLg may intercept some of these keys, so
;; `C-c i' remains the reliable prefix.
(global-set-key (kbd "s-b") #'xref-find-definitions)
(global-set-key (kbd "s-u") #'xref-find-references)
(global-set-key (kbd "s-r") #'ec-rename-symbol)
(global-set-key (kbd "s-[") #'xref-go-back)
(global-set-key (kbd "s-]") #'xref-go-forward)
(global-set-key (kbd "s-o") #'project-find-file)
(global-set-key (kbd "s-f") #'consult-ripgrep)
(global-set-key (kbd "s-e") #'consult-buffer)
(global-set-key (kbd "s-m") #'consult-imenu)
(global-set-key (kbd "s-p") #'project-switch-project)
(global-set-key (kbd "s-g") #'magit-status)
(global-set-key (kbd "s-t") #'tab-new)
(global-set-key (kbd "s-w") #'tab-close)

(provide 'ec-keymap)
;;; ec-keymap.el ends here
