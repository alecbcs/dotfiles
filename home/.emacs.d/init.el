;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of Emacs.

;;;; Code:

;; ===========================================================================
;; Setup Package Managers
;; ===========================================================================
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(setq package-enable-at-startup nil)
(package-initialize)

;; set up the package manager or install if missing
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
  ;; scroll one line at a time
  (setq scroll-step 1)
  (setq scroll-conservatively 10000)

  ;; no menu bar
  (menu-bar-mode -1)

  ;; no tool bar
  (tool-bar-mode -1)

  ;; disable emacs alarms
  (setq ring-bell-function 'ignore)

  ;; don't use customize
  (setq custom-file null-device)

  ;; allow following symlinks
  (setq vc-follow-symlinks t)

  ;; set tabs to equal 4 spaces
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab)

  ;; remove trailing whitespace
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  ;; enfoce a final newline in files
  (setq require-final-newline t)

  ;; automatically make scripts executable if they have shebant (#!) in them
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
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; ===========================================================================
;; Load Additional Configuration Files
;; ===========================================================================
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
(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

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
  :ensure t
  :config
  (ido-mode +1)
  (setq ido-everywhere t
    ido-enable-flex-matching t))

(use-package ido-vertical-mode
  :ensure t
  :config
  (ido-vertical-mode +1)
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))

(use-package ido-completing-read+
  :ensure t
  :config (ido-ubiquitous-mode +1))

(use-package flx-ido
  :ensure t
  :config (flx-ido-mode +1))

(use-package company
  :diminish company-mode
  :ensure t
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

;;; init.el ends here
