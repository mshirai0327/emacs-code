;;; init.el --- Personal Emacs entrypoint -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'ec-core)
(require 'ec-ui)
(require 'ec-completion)
(require 'ec-navigation)
(require 'ec-prog)
(require 'ec-layout)
(require 'ec-terminal)
(require 'ec-keymap)

(provide 'init)
;;; init.el ends here
