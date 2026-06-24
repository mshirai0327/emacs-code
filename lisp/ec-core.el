;;; ec-core.el --- Core package and path setup -*- lexical-binding: t; -*-

(defgroup ec nil
  "Personal Emacs configuration."
  :group 'convenience)

(defcustom ec-auto-install-packages
  (not (getenv "EC_NO_PACKAGE_INSTALL"))
  "When non-nil, install missing packages during startup."
  :type 'boolean
  :group 'ec)

(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(defconst ec-required-packages
  '(use-package
    vertico
    orderless
    marginalia
    consult
    embark
    corfu
    magit
    treemacs
    typescript-mode
    vscode-dark-plus-theme
    web-mode
    which-key
    go-mode
    markdown-mode
    yaml-mode)
  "Packages used by this configuration.")

(defun ec-refresh-package-contents-once ()
  "Refresh package metadata when it is missing."
  (unless package-archive-contents
    (package-refresh-contents)))

(defun ec-ensure-package (package)
  "Install PACKAGE unless it is already available."
  (unless (package-installed-p package)
    (ec-refresh-package-contents-once)
    (condition-case err
        (package-install package)
      (file-error
       (message "Retrying package install for %S after refreshing metadata: %s"
                package
                (error-message-string err))
       (package-refresh-contents)
       (package-install package)))))

(when ec-auto-install-packages
  (dolist (package ec-required-packages)
    (ec-ensure-package package)))

(unless (require 'use-package nil t)
  (error "use-package is not available. Use Emacs 29+ or install use-package"))

(setq use-package-always-ensure ec-auto-install-packages)
(setq use-package-expand-minimally t)

(defun ec-add-to-exec-path (dir)
  "Add DIR to `exec-path' and PATH when DIR exists."
  (when (and dir (file-directory-p dir))
    (add-to-list 'exec-path dir)
    (setenv "PATH" (concat dir path-separator (getenv "PATH")))))

(ec-add-to-exec-path (expand-file-name "go/bin" (getenv "HOME")))
(ec-add-to-exec-path (expand-file-name ".local/bin" (getenv "HOME")))

(setq custom-file (expand-file-name "var/custom.el" user-emacs-directory))
(make-directory (file-name-directory custom-file) t)
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'ec-core)
;;; ec-core.el ends here
