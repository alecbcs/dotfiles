;;;; init.el -- personal main emacs config
;;;; Commentary:

;; An opinionated setup for my customized version of Emacs.

;;;; Code:

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

  ;; automatically make scripts executable if they have shebang (#!) in them
  (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

  ;; add additional key binding for ansi-term
  (global-set-key (kbd "C-c C-t") 'ansi-term)

  ;; set tramp to use .ssh/config settings
  (customize-set-variable 'tramp-use-ssh-controlmaster-options nil)

  ;; load theme
  (load-theme 'twilight t)

  ;; add the location on additional configs
  (add-to-list 'load-path (expand-file-name "init" user-emacs-directory))

  :hook
  ;; remove trailing whitespace
  (before-save . delete-trailing-whitespace)

  ;; enable line numbers in programming modes
  (prog-mode . display-line-numbers-mode)

  :custom
  ;; prevent line number column from shifting text left/right
  (display-line-numbers-width-start t)

  ;; scroll one line at a time
  (scroll-step 1)
  (scroll-conservatively 10000)

  ;; default text-mode instead of fundamental mode
  (major-mode 'text-mode)

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

  ;; enforce a final newline in files
  (require-final-newline t)

  ;; when using a mac allow option key as meta
  (when (equal system-type 'darwin)
    (mac-command-modifier 'super)
    (mac-option-modifier 'meta))

  ;; use custom file in emacs directory
  (custom-file (expand-file-name "custom.el" user-emacs-directory))

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
  :defer nil
  :config
  (ignore-errors (xclip-mode 1)))

(use-package flyspell
  :ensure t
  :hook
  (text-mode . (lambda () (let ((inhibit-message t)) (flyspell-mode))))
  (prog-mode . (lambda () (let ((inhibit-message t)) (flyspell-prog-mode))))
  :config
  (setq flyspell-issue-message-flag nil)
  (global-set-key (kbd "C-\\") 'save-word)
  (defun save-word ()
    (interactive)
    (let ((current-location (point))
          (word (flyspell-get-word)))
      (when (consp word)
        (flyspell-do-correct 'save nil (car word) current-location
                             (cadr word) (caddr word) current-location)))))

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
  (auto-revert-interval 5)
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

(use-package olivetti
  :ensure t
  :hook
  (markdown-mode . olivetti-mode)
  (org-mode . olivetti-mode)
  (rst-mode . olivetti-mode)
  :custom
  (olivetti-body-width 80))

(use-package vertico
  :ensure t
  :defer nil
  :config
  (vertico-mode 1)
  :custom
  (vertico-count 10)
  (vertico-cycle t)
  (vertico-resize nil)
  (vertico-preselect 'first))

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
  :defer nil
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-auto-cycle t)
  (corfu-preselect 'prompt)
  (tab-always-indent 'complete)
  :config
  (global-corfu-mode))

(use-package corfu-terminal
  :ensure t
  :after corfu
  :defer nil
  :config
  ;; use corfu-terminal when not running as graphical emacs
  (unless (display-graphic-p) (corfu-terminal-mode +1)))

(use-package cape
  :ensure t
  :after corfu
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  :custom
  (cape-dabbrev-min-length 3))

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)
  (rg-enable-menu))

(use-package whole-line-or-region
  :ensure t
  :custom
  (whole-line-or-region-global-mode t))

;;; init.el ends here
