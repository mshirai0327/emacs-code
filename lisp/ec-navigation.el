;;; ec-navigation.el --- Project and xref navigation -*- lexical-binding: t; -*-

(use-package project
  :ensure nil
  :custom
  (project-switch-commands
   '((project-find-file "Find file")
     (consult-ripgrep "Ripgrep")
     (magit-status "Magit")
     (project-shell "Shell"))))

(use-package xref
  :ensure nil
  :custom
  (xref-search-program 'ripgrep))

(provide 'ec-navigation)
;;; ec-navigation.el ends here
