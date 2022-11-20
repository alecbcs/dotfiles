;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of Emacs.

;;;; Code:

;; ===========================================================================
;; Setup Package Managers
;; ===========================================================================
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; Setting up the package manager. Install if missing.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t))

;; ===========================================================================
;; General Options
;; ===========================================================================
(use-package emacs
  :config
  ;; declare window decorations as dark to match with theme
  (set-frame-parameter nil 'ns-appearance 'dark)
  (set-frame-parameter nil 'ns-transparent-titlebar nil)

  ;; no menu bar
  (menu-bar-mode -1)

  ;; allow following symlinks
  (setq vc-follow-symlinks t)

  ;; no tool bar
  (tool-bar-mode -1)

  ;; standard tabs to 4 spaces
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab)

  ;; remove trailing whitespace
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  ; Comment regions or lines with M-#
  (defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if
     there's no active region."
    (interactive)
    (let (beg end)
      (if (region-active-p)
          (setq beg (region-beginning) end (region-end))
        (setq beg (line-beginning-position) end (line-end-position)))
      (comment-or-uncomment-region beg end)))
  (global-set-key [?\M-#] 'comment-or-uncomment-region-or-line)

  ;; enfoce a final newline in files
  (setq require-final-newline t)

  ;; Automatically make scripts executable if they have shebant (#!) in them
  (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

  ;; add additional key binding for ansi-term
  (global-set-key (kbd "C-c C-t") 'ansi-term)

  ;; set tramp to use .ssh/config settings
  (customize-set-variable 'tramp-use-ssh-controlmaster-options nil)

  ;; when using a mac allow option key as meta
  (when (equal system-type 'darwin)
    (setq mac-command-modifier 'super)
    (setq mac-option-modifier 'meta))

  ;; add the location on additional configs
  (add-to-list 'load-path (expand-file-name "init" user-emacs-directory))
  (defconst *spell-check-support-enabled* t)

  ;; enable visual line mode
  (setq visual-line-mode 1)

  ;; no info screen at startup
  (setq inhibit-startup-screen t)
  (load-theme 'twilight t))

;; ===========================================================================
;; $PATH within Emacs
;; ===========================================================================
;; import $PATH from the external shell env
(use-package exec-path-from-shell
  :config (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; ===========================================================================
;; Load Additional Configuration Files
;; ===========================================================================
;; load lsp-mode config from file.
(require 'init-lsp)

;; load org-mode config from file.
(require 'init-org)

;; load markdown-mode config from file.
(require 'init-markdown)

;; load dired-sidebar config from file.
(require 'init-sidebar)

;; load programming languages config from file.
(require 'init-prog-langs)

;; load docker tramp from file.
(require 'init-podman)

;; ===========================================================================
;; Load Additional Packages
;; ===========================================================================
(use-package simple
  :ensure nil
  :config (column-number-mode +1))

(use-package files
  :ensure nil
  :config
  (setq confirm-kill-processes nil
    create-lockfiles nil ; don't create .# files (crashes 'npm start')
    make-backup-files nil))

(use-package autorevert
  :ensure nil
  :config
  (global-auto-revert-mode +1)
  (setq auto-revert-interval 2
    auto-revert-check-vc-info t
    global-auto-revert-non-file-buffers t
    auto-revert-verbose nil))

(use-package paren
  :ensure nil
  :init (setq show-paren-delay 0)
  :config (show-paren-mode +1))

(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

(use-package whitespace
  :ensure nil
  :hook (before-save . whitespace-cleanup))

(use-package ido
  :config
  (ido-mode +1)
  (setq ido-everywhere t
    ido-enable-flex-matching t))

(use-package ido-vertical-mode
  :config
  (ido-vertical-mode +1)
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))

(use-package ido-completing-read+
  :config (ido-ubiquitous-mode +1))

(use-package flx-ido
  :config (flx-ido-mode +1))

(use-package company
  :diminish company-mode
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1
    company-idle-delay 0.1
    company-selection-wrap-around t
    company-tooltip-align-annotations t
    company-frontends '(company-pseudo-tooltip-frontend ; show tooltip even for single candidate
                company-echo-metadata-frontend))
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(use-package flycheck
  :config (global-flycheck-mode +1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(package-selected-packages
   '(projector project-root exec-path-from-shell web-mode flycheck flx-ido ido-completing-read+ ido-vertical-mode company sp-ui-doc-frame lsp-ui go-mode lsp-mode visual-fill dired-sidebar visual-fill-column org markdown-mode))
 '(tab-stop-list
   '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
