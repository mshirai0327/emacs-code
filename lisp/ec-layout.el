;;; ec-layout.el --- Tabs and buffer display rules -*- lexical-binding: t; -*-

(require 'project)

(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 1)
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  :config
  (tab-bar-mode 1))

(use-package tab-line
  :ensure nil
  :custom
  (tab-line-close-button-show nil)
  (tab-line-new-button-show nil)
  (tab-line-switch-cycling t)
  (tab-line-exclude-modes
   '(completion-list-mode
     compilation-mode
     eshell-mode
     help-mode
     magit-status-mode
     shell-mode
     treemacs-mode))
  :config
  (global-tab-line-mode 1))

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

(use-package treemacs
  :defer t
  :commands
  (treemacs
   treemacs-add-and-display-current-project-exclusively
   treemacs-filewatch-mode
   treemacs-find-file
   treemacs-follow-mode
   treemacs-fringe-indicator-mode
   treemacs-git-mode
   treemacs-select-directory
   treemacs-select-window)
  :custom
  (treemacs-position 'left)
  (treemacs-width 34)
  (treemacs-follow-after-init t)
  (treemacs-expand-after-init t)
  (treemacs-sorting 'alphabetic-asc)
  :config
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1)
  (treemacs-fringe-indicator-mode 'always)
  (when (executable-find "git")
    (treemacs-git-mode 'simple)))

(defun ec-open-project-tree ()
  "Open a VS Code-like project tree for the current project."
  (interactive)
  (unless (require 'treemacs nil t)
    (user-error "Treemacs is not installed; restart Emacs with package auto-install enabled"))
  (if (project-current nil)
      (treemacs-add-and-display-current-project-exclusively)
    (call-interactively #'treemacs-select-directory)))

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
