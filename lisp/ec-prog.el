;;; ec-prog.el --- Programming language setup -*- lexical-binding: t; -*-

(defun ec-treesit-language-available-p (language)
  "Return non-nil when tree-sitter LANGUAGE grammar is available."
  (and (fboundp 'treesit-available-p)
       (treesit-available-p)
       (fboundp 'treesit-language-available-p)
       (treesit-language-available-p language)))

(defun ec-use-go-mode ()
  "Use tree-sitter Go mode when available, otherwise `go-mode'."
  (interactive)
  (if (fboundp 'go-ts-mode)
      (go-ts-mode)
    (go-mode)))

(defun ec-use-typescript-mode ()
  "Use the best available TypeScript mode."
  (interactive)
  (cond
   ((and (fboundp 'typescript-ts-mode)
         (ec-treesit-language-available-p 'typescript))
    (typescript-ts-mode))
   ((require 'typescript-mode nil t) (typescript-mode))
   ((fboundp 'typescript-mode) (typescript-mode))
   (t (js-mode))))

(defun ec-use-tsx-mode ()
  "Use the best available TSX mode."
  (interactive)
  (cond
   ((and (fboundp 'tsx-ts-mode)
         (ec-treesit-language-available-p 'tsx))
    (tsx-ts-mode))
   ((require 'web-mode nil t) (web-mode))
   ((and (fboundp 'typescript-ts-mode)
         (ec-treesit-language-available-p 'typescript))
    (typescript-ts-mode))
   ((require 'typescript-mode nil t) (typescript-mode))
   ((fboundp 'js-jsx-mode) (js-jsx-mode))
   (t (js-mode))))

(add-to-list 'auto-mode-alist '("\\.go\\'" . ec-use-go-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . ec-use-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . ec-use-tsx-mode))

(use-package eglot
  :ensure nil
  :hook
  ((go-mode . eglot-ensure)
   (go-ts-mode . eglot-ensure)
   (typescript-mode . eglot-ensure)
   (typescript-ts-mode . eglot-ensure)
   (tsx-ts-mode . eglot-ensure)
   (web-mode . eglot-ensure)
   (js-mode . eglot-ensure)
   (js-ts-mode . eglot-ensure)
   (js-jsx-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  :config
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("gopls")))
  (add-to-list 'eglot-server-programs
               '((typescript-mode typescript-ts-mode tsx-ts-mode
                  (web-mode :language-id "typescriptreact")
                  js-mode js-ts-mode js-jsx-mode)
                 . ("typescript-language-server" "--stdio"))))

(use-package go-mode
  :defer t)

(use-package typescript-mode
  :defer t
  :custom
  (typescript-indent-level 2))

(use-package web-mode
  :defer t
  :custom
  (web-mode-code-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-markup-indent-offset 2))

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(provide 'ec-prog)
;;; ec-prog.el ends here
