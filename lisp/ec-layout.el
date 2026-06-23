;;; ec-layout.el --- Tabs and buffer display rules -*- lexical-binding: t; -*-

(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 1)
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  :config
  (tab-bar-mode 1))

(use-package winner
  :ensure nil
  :config
  (winner-mode 1))

(defun ec-project-root ()
  "Return the current project root or `default-directory'."
  (if-let ((project (project-current nil)))
      (project-root project)
    default-directory))

(defun ec-rename-tab-to-project ()
  "Rename current tab to the current project name."
  (interactive)
  (let* ((root (directory-file-name (ec-project-root)))
         (name (file-name-nondirectory root)))
    (tab-bar-rename-tab name)))

(defun ec-new-project-tab (directory)
  "Create a new tab for DIRECTORY and find a project file."
  (interactive "DProject directory: ")
  (tab-new)
  (let ((default-directory directory))
    (ec-rename-tab-to-project)
    (project-find-file)))

(setq display-buffer-alist
      '(("\\*\\(compilation\\|grep\\|xref\\|Flymake diagnostics\\).*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom)
         (slot . 0)
         (window-height . 0.28))
        ("\\*\\(Help\\|eldoc\\|Embark Actions\\).*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . right)
         (slot . 0)
         (window-width . 0.34))
        ("\\*\\(shell\\|eshell\\|terminal\\|ai-shell\\).*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom)
         (slot . 1)
         (window-height . 0.30))
        ("\\*magit.*"
         (display-buffer-same-window))))

(provide 'ec-layout)
;;; ec-layout.el ends here
