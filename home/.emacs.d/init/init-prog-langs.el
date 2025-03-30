;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of Emacs programming language modes.

;;;; Code:
;; ===========================================================================
;; Common Development Tools
;; ===========================================================================
(use-package treesit-auto
  :ensure t
  :custom
  (setq treesit-auto-install 't)
  (global-treesit-auto-mode))

(use-package envrc
  :ensure t
  :config
  (envrc-global-mode))

(use-package eglot
  :ensure t
  :custom
  (eglot-report-progress nil)
  (eglot-send-changes-idle-time 3)
  (fset #'jsonrpc--log-event #'ignore)
  :config
  (setq-default eglot-workspace-configuration
    '((:pylsp . (:plugins (:ruff (:enabled t :lineLength 88
      :formatEnabled t)))))))

(use-package flycheck
  :ensure t
  :custom
  (global-flycheck-mode))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :custom
  (global-flycheck-eglot-mode 1)
  (eglot-events-buffer-config '(:size 0)))

;; ===========================================================================
;; Python
;; ===========================================================================
(use-package python-mode
  :ensure t
  :defer t
  :hook
  (python-mode-hook . eglot-ensure)
  (python-ts-mode-hook . eglot-ensure))

;; ===========================================================================
;; Go
;; ===========================================================================
(use-package go-mode
  :ensure t
  :custom
  (go-ts-mode-indent-offset 4)
  (go-mode-indent-offset 4)
  :hook
  (go-mode-hook . eglot-ensure)
  (go-ts-mode-hook . eglot-ensure)
  (before-save-hook . eglot-format-buffer))

(use-package gotest
  :ensure t
  :defer t
  :after go-mode)

;; ===========================================================================
;; Rust
;; ===========================================================================
(use-package rust-mode
  :ensure t
  :custom
  (rust-format-on-save t)
  :hook
  (rust-mode-hook . eglot-ensure)
  (rust-ts-mode-hook . eglot-ensure))

(use-package flycheck-rust
  :ensure t
  :after (flycheck rust-mode)
  :hook
  (flycheck-mode-hook . flycheck-rust-setup))

;; ===========================================================================
;; YAML
;; ===========================================================================
(use-package yaml-mode
  :ensure t
  :defer t
  :mode ("\\.ya?ml\\'" . yaml-mode))

;; ===========================================================================
;; JSON
;; ===========================================================================
(use-package json-mode
  :ensure t
  :defer t)

(provide 'init-prog-langs)

;;; init-prog-langs.el ends here
