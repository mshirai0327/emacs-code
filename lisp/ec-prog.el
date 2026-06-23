;;; ec-prog.el --- Programming language setup -*- lexical-binding: t; -*-

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
   ((fboundp 'typescript-ts-mode) (typescript-ts-mode))
   ((fboundp 'typescript-mode) (typescript-mode))
   (t (js-mode))))

(defun ec-use-tsx-mode ()
  "Use the best available TSX mode."
  (interactive)
  (cond
   ((fboundp 'tsx-ts-mode) (tsx-ts-mode))
   ((fboundp 'typescript-ts-mode) (typescript-ts-mode))
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
                  js-mode js-ts-mode js-jsx-mode)
                 . ("typescript-language-server" "--stdio"))))

(use-package go-mode
  :defer t)

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(provide 'ec-prog)
;;; ec-prog.el ends here
