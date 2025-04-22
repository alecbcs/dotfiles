;;;; init.el -- personal main emacs config
;;;; Commentary:

;; An opinionated setup for my customized version of Emacs.

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
  (setq use-package-always-ensure t)
  (setq use-package-verbose nil)
  (setq use-package-compute-statistics nil))

;; ===========================================================================
;; General Options
;; ===========================================================================
(use-package emacs
  :config
  ;; no menu bar
  (menu-bar-mode -1)

  ;; no tool bar
  (tool-bar-mode -1)

  ;; auto close bracket insertion
  (electric-pair-mode 1)

  ;; automatically make scripts executable if they have shebant (#!) in them
  (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

  ;; add additional key binding for ansi-term
  (global-set-key (kbd "C-c C-t") 'ansi-term)

  ;; set tramp to use .ssh/config settings
  (customize-set-variable 'tramp-use-ssh-controlmaster-options nil)

  ;; enable spellcheck
  (defconst *spell-check-support-enabled* t)

  ;; load theme
  (load-theme 'twilight t)

  ;; add the location on additional configs
  (add-to-list 'load-path (expand-file-name "init" user-emacs-directory))

  :hook
  ;; remove trailing whitespace
  (before-save . delete-trailing-whitespace)

  :custom
  ;; scroll one line at a time
  (scroll-step 1)
  (scroll-conservatively 10000)

  ;; disable emacs alarms
  (ring-bell-function 'ignore)

  ;; no info screen at startup
  (inhibit-startup-screen t)

  ;; allow following symlinks
  (vc-follow-symlinks t)

  ;; set tabs to equal 4 spaces
  (indent-tabs-mode nil)
  (tab-width 4)
  (indent-line-function 'insert-tab)

  ;; enfoce a final newline in files
  (require-final-newline t)

  ;; when using a mac allow option key as meta
  (when (equal system-type 'darwin)
    (mac-command-modifier 'super)
    (mac-option-modifier 'meta))

  ;; don't use customize
  (custom-file null-device)

  ;; enable visual line mode
  (visual-line-mode 1)

  ;; enforce eldoc to only use a single line
  (eldoc-echo-area-use-multiline-p nil)

  ;; hide commands from M-x that aren't possible
  (read-extended-command-predicate #'command-completion-default-include-p)

  ;; allow minibuffers to be opened from minibuffers
  (enable-recursive-minibuffers t)

  ;; don't allow cursor in the minibuffer
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; ===========================================================================
;; Optimize Emacs's garbage collector for better performance
;; ===========================================================================
(use-package gcmh
  :ensure t
  :config
  (gcmh-mode 1)
  :custom
  (gcmh-idle-delay 5)
  (gcmh-high-cons-threshold 16777216)) ;; 16MB

;; ===========================================================================
;; $PATH within Emacs
;; ===========================================================================
;; import $PATH from the external shell env
(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize))

;; ===========================================================================
;; Load Additional Configuration Files
;; ===========================================================================
(require 'init-org)
(require 'init-markdown)
(require 'init-sidebar)
(require 'init-prog-langs)
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

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package files
  :ensure nil
  :custom
  (confirm-kill-processes nil)
  (create-lockfiles nil ) ;; don't create .# files (crashes 'npm start')
  (make-backup-files nil))

(use-package autorevert
  :ensure t
  :config
  (global-auto-revert-mode +1)
  :custom
  (auto-revert-interval 2)
  (auto-revert-check-vc-info t)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil))

(use-package paren
  :ensure t
  :config
  (show-paren-mode +1)
  :custom
  (show-paren-delay 0))

(use-package whitespace
  :ensure t
  :hook (before-save . whitespace-cleanup))


(use-package vertico
  :ensure t
  :custom
  (vertico-count 10)
  (vertico-cycle t)
  (vertico-resize nil)
  (vertico-preselect 'first)
  (vertico-mode 1))

(use-package vertico-directory
  :after vertico
  :ensure nil ;; no need to install, comes with vertico
  :bind (:map vertico-map
    ("RET"   . vertico-directory-enter)
    ("DEL"   . vertico-directory-delete-char)
    ("M-DEL" . vertico-directory-delete-word)))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (style partial-completion)))))

(use-package consult
  :ensure t
  :custom
  (consult-preview-key nil)
  :bind
  (("C-x b" . 'consult-buffer)    ;; Switch buffer, including recent and bookmarks
   ("M-l"   . 'consult-git-grep)  ;; Search inside a project
   ("M-y"   . 'consult-yank-pop)  ;; Paste by selecting the kill-ring
   ("M-s"   . 'consult-line)      ;; Search current buffer, like swiper
   ))

(use-package embark
  :ensure t
  :bind
  (("C-."   . embark-act)
   ("C-;"   . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)))  ;; alternative for `describe-bindings`

(use-package embark-consult
  :after (embark consult)
  :ensure t)

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (tab-always-indent 'complete)
  :init
  (global-corfu-mode))

(use-package corfu-terminal
  :ensure t
  :config
  ;; use corfu-terminal when not running as graphical emacs
  (unless (display-graphic-p) (corfu-terminal-mode +1)))

(use-package cape
  :ensure t
  :after corfu
  :hook
  (completion-at-point-functions . cape-file))

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)
  (rg-enable-menu))

;;; init.el ends here
