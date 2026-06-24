;;; ec-ui.el --- UI defaults -*- lexical-binding: t; -*-

(defcustom ec-theme 'vscode-dark-plus
  "Theme loaded by this configuration."
  :type '(choice (const :tag "VS Code Dark+" vscode-dark-plus)
                 (symbol :tag "Other theme")
                 (const :tag "No theme" nil))
  :group 'ec)

(defconst ec-vscode-dark+-colors
  '((bg . "#1e1e1e")
    (bg-alt . "#252526")
    (bg-panel . "#181818")
    (bg-active . "#1f1f1f")
    (fg . "#d4d4d4")
    (fg-dim . "#858585")
    (border . "#3c3c3c")
    (blue . "#007acc")
    (selection . "#264f78")
    (line . "#2a2d2e"))
  "Small VS Code Dark+ palette used for UI faces not covered by the theme.")

(defun ec-vscode-dark+-color (name)
  "Return VS Code Dark+ palette color NAME."
  (alist-get name ec-vscode-dark+-colors))

(defun ec-set-face-attribute-when-defined (face &rest args)
  "Apply ARGS to FACE when FACE is already defined."
  (when (facep face)
    (apply #'set-face-attribute face nil args)))

(defun ec-apply-vscode-dark+-face-tweaks ()
  "Tune built-in and package UI faces after loading VS Code Dark+."
  (let ((bg (ec-vscode-dark+-color 'bg))
        (bg-alt (ec-vscode-dark+-color 'bg-alt))
        (bg-panel (ec-vscode-dark+-color 'bg-panel))
        (bg-active (ec-vscode-dark+-color 'bg-active))
        (fg (ec-vscode-dark+-color 'fg))
        (fg-dim (ec-vscode-dark+-color 'fg-dim))
        (border (ec-vscode-dark+-color 'border))
        (blue (ec-vscode-dark+-color 'blue))
        (selection (ec-vscode-dark+-color 'selection))
        (line (ec-vscode-dark+-color 'line)))
    (ec-set-face-attribute-when-defined 'default :background bg :foreground fg)
    (ec-set-face-attribute-when-defined 'fringe :background bg :foreground fg-dim)
    (ec-set-face-attribute-when-defined 'line-number :background bg :foreground fg-dim)
    (ec-set-face-attribute-when-defined 'line-number-current-line
                                        :background bg :foreground fg)
    (ec-set-face-attribute-when-defined 'hl-line :background line)
    (ec-set-face-attribute-when-defined 'region :background selection)
    (ec-set-face-attribute-when-defined 'mode-line
                                        :background blue :foreground "#ffffff"
                                        :box `(:line-width 1 :color ,blue))
    (ec-set-face-attribute-when-defined 'mode-line-inactive
                                        :background bg-alt :foreground fg-dim
                                        :box `(:line-width 1 :color ,bg-alt))
    (ec-set-face-attribute-when-defined 'header-line
                                        :background bg-alt :foreground fg
                                        :box `(:line-width 1 :color ,border))
    (ec-set-face-attribute-when-defined 'tab-bar
                                        :background bg-panel :foreground fg-dim)
    (ec-set-face-attribute-when-defined 'tab-bar-tab
                                        :background bg-active :foreground fg
                                        :box `(:line-width 1 :color ,bg-active))
    (ec-set-face-attribute-when-defined 'tab-bar-tab-inactive
                                        :background bg-panel :foreground fg-dim
                                        :box `(:line-width 1 :color ,bg-panel))
    (ec-set-face-attribute-when-defined 'tab-line
                                        :background bg-alt :foreground fg-dim
                                        :box `(:line-width 1 :color ,bg-alt))
    (ec-set-face-attribute-when-defined 'tab-line-tab
                                        :background bg :foreground fg
                                        :box `(:line-width 1 :color ,bg))
    (ec-set-face-attribute-when-defined 'tab-line-tab-current
                                        :background bg :foreground fg
                                        :box `(:line-width 1 :color ,blue))
    (ec-set-face-attribute-when-defined 'tab-line-tab-inactive
                                        :background bg-alt :foreground fg-dim
                                        :box `(:line-width 1 :color ,bg-alt))
    (ec-set-face-attribute-when-defined 'minibuffer-prompt
                                        :foreground blue :weight 'semi-bold)
    (with-eval-after-load 'treemacs
      (ec-set-face-attribute-when-defined 'treemacs-root-face
                                          :foreground fg :weight 'bold)
      (ec-set-face-attribute-when-defined 'treemacs-directory-face :foreground fg)
      (ec-set-face-attribute-when-defined 'treemacs-file-face :foreground fg)
      (ec-set-face-attribute-when-defined 'treemacs-git-modified-face
                                          :foreground "#d7ba7d")
      (ec-set-face-attribute-when-defined 'treemacs-git-added-face
                                          :foreground "#6a9955")
      (ec-set-face-attribute-when-defined 'treemacs-git-untracked-face
                                          :foreground "#4ec9b0"))))

(defun ec-load-theme ()
  "Load `ec-theme' and keep startup usable if the theme is missing."
  (when ec-theme
    (condition-case err
        (progn
          (mapc #'disable-theme custom-enabled-themes)
          (load-theme ec-theme t)
          (when (eq ec-theme 'vscode-dark-plus)
            (ec-apply-vscode-dark+-face-tweaks)
            (with-eval-after-load 'tab-bar
              (ec-apply-vscode-dark+-face-tweaks))
            (with-eval-after-load 'tab-line
              (ec-apply-vscode-dark+-face-tweaks))))
      (error
       (message "Could not load theme %S: %s" ec-theme (error-message-string err))))))

(setq vscode-dark-plus-render-line-highlight 'line)
(setq vscode-dark-plus-scale-org-faces nil)

(use-package emacs
  :ensure nil
  :custom
  (inhibit-startup-screen t)
  (ring-bell-function #'ignore)
  (make-backup-files nil)
  (auto-save-default nil)
  (create-lockfiles nil)
  (use-dialog-box nil)
  (scroll-conservatively 101)
  (scroll-margin 4)
  (indent-tabs-mode nil)
  (tab-width 4)
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (global-hl-line-mode 1)
  (column-number-mode 1)
  (global-display-line-numbers-mode 1)
  (ec-load-theme)
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
