;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of Emacs programming language modes.

;;;; Code:
;; ===========================================================================
;; Python
;; ===========================================================================
(use-package python-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'eglot-ensure))

;; ===========================================================================
;; Go
;; ===========================================================================
(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'eglot-ensure)
  (add-hook 'go-ts-mode-hook 'eglot-ensure)
  (add-hook 'before-save-hook 'eglot-format-buffer))

(use-package gotest
  :ensure t)

;; ===========================================================================
;; Rust
;; ===========================================================================
(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t)
  (add-hook 'rust-mode-hook 'eglot-ensure)
  (add-hook 'rust-ts-mode-hook 'eglot-ensure))

(use-package flycheck-rust
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook 'flycheck-rust-setup))

;; ===========================================================================
;; YAML
;; ===========================================================================
(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

;; ===========================================================================
;; JSON
;; ===========================================================================
(use-package json-mode
  :ensure t)

;; ===========================================================================
;; Common Tools
;; ===========================================================================
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 't)
  (global-treesit-auto-mode))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package envrc
  :ensure t
  :config
  (envrc-global-mode))

(use-package eglot
  :ensure t
  :config
  (setq eglot-report-progress nil))

(provide 'init-prog-langs)

;;; init-prog-langs.el ends here
