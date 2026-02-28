;;;; init-prog-langs.el -- preferences for configuring programming modes
;;;; Commentary:

;; An opinionated setup for my customized version of Emacs.

;;;; Code:
;; ===========================================================================
;; Common Development Tools
;; ===========================================================================
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 't)
  (global-treesit-auto-mode))

(use-package envrc
  :ensure t
  :defer nil
  :config
  (envrc-global-mode))

(use-package eglot
  :ensure t
  :config
  (fset #'jsonrpc--log-event #'ignore)
  :custom
  (eglot-report-progress nil)
  (eglot-send-changes-idle-time 5)
  (setq eglot-workspace-configuration
    '((:pylsp . (:plugins (:ruff (:enabled t :lineLength 88
      :formatEnabled t)))))))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (setq eglot-events-buffer-config '(:size 0))
  (global-flycheck-eglot-mode 1))

(use-package magit
  :ensure t
  :defer nil)

;; ===========================================================================
;; Python
;; ===========================================================================
(use-package python-mode
  :ensure t
  :hook
  (python-mode . eglot-ensure)
  (python-ts-mode . eglot-ensure)
  (python-mode . (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
  (python-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

;; ===========================================================================
;; Go
;; ===========================================================================
(use-package go-mode
  :ensure t
  :custom
  (go-ts-mode-indent-offset 4)
  (go-mode-indent-offset 4)
  :hook
  (go-mode . eglot-ensure)
  (go-ts-mode . eglot-ensure)
  (go-mode . (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
  (go-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

(use-package gotest
  :ensure t
  :after go-mode)

;; ===========================================================================
;; Rust
;; ===========================================================================
(use-package rust-mode
  :ensure t
  :custom
  (rust-format-on-save t)
  :hook
  (rust-mode . eglot-ensure)
  (rust-ts-mode . eglot-ensure))

(use-package flycheck-rust
  :ensure t
  :after (flycheck rust-mode)
  :hook
  (flycheck-mode . flycheck-rust-setup))

;; ===========================================================================
;; YAML
;; ===========================================================================
(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode))

;; ===========================================================================
;; JSON
;; ===========================================================================
(use-package json-mode
  :ensure t
  :custom
  (js-indent-level 2))

(provide 'init-prog-langs)

;;; init-prog-langs.el ends here
