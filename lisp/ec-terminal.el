;;; ec-terminal.el --- Project-aware shells -*- lexical-binding: t; -*-

(defun ec-shell (&optional name)
  "Open a shell at the current project root.
With optional NAME, use it as the shell buffer name."
  (interactive)
  (let ((default-directory (ec-project-root)))
    (shell (or name "*shell*"))))

(defun ec-ai-shell ()
  "Open a separate shell intended for AI CLI tools."
  (interactive)
  (ec-shell "*ai-shell*"))

(defun ec-eshell ()
  "Open eshell at the current project root."
  (interactive)
  (let ((default-directory (ec-project-root)))
    (eshell t)))

(provide 'ec-terminal)
;;; ec-terminal.el ends here
