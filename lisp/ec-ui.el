;;; ec-ui.el --- UI defaults -*- lexical-binding: t; -*-

(use-package emacs
  :ensure nil
  :custom
  (inhibit-startup-screen t)
  (ring-bell-function #'ignore)
  (make-backup-files nil)
  (auto-save-default nil)
  (create-lockfiles nil)
  (scroll-conservatively 101)
  (scroll-margin 4)
  (indent-tabs-mode nil)
  (tab-width 4)
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (column-number-mode 1)
  (global-display-line-numbers-mode 1)
  (dolist (hook '(term-mode-hook
                  shell-mode-hook
                  eshell-mode-hook
                  help-mode-hook
                  compilation-mode-hook))
    (add-hook hook (lambda () (display-line-numbers-mode -1)))))

(use-package which-key
  :config
  (which-key-mode 1))

(provide 'ec-ui)
;;; ec-ui.el ends here
