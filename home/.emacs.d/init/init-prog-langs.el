;;;; init-prog-langs.el -- preferences for configuring programming modes
;;;; Commentary:

;; An opinionated setup for my customized version of Emacs.

;;;; Code:
;; ===========================================================================
;; Common Development Tools
;; ===========================================================================
(use-package treesit
  :ensure nil
  :when (treesit-available-p)
  :custom
  (major-mode-remap-alist
   '((go-mode . go-ts-mode)
     (json-mode . json-ts-mode)
     (python-mode . python-ts-mode)
     (rust-mode . rust-ts-mode))))

(use-package envrc
  :ensure t
  :defer nil
  :config
  (envrc-global-mode))

(use-package eglot
  :ensure t
  :config
  (remove-hook 'jsonrpc-event-hook #'jsonrpc--log-event)
  (add-to-list 'eglot-server-programs
               '((python-ts-mode python-mode)
                 . ("rass" "--" "pylsp" "--" "ty" "server" "--" "ruff" "server")))
  :hook
  (eglot-managed-mode . eglot-ensure)
  :custom
  (eglot-events-buffer-config '(:size 0))
  (eglot-report-progress nil)
  (eglot-send-changes-idle-time 5)
  (eglot-ignored-server-capabilities '(:inlayHintProvider :signatureHelpProvider)))

(use-package flymake
  :ensure nil
  :hook
  (prog-mode . flymake-mode)
  (flymake-mode . (lambda ()
                    (setq-local eldoc-documentation-functions
                                (cons #'flymake-eldoc-function
                                      (remove #'flymake-eldoc-function
                                              eldoc-documentation-functions))))))

(use-package apheleia
  :ensure t
  :demand t
  :config
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (apheleia-global-mode +1))

(use-package magit
  :ensure t
  :demand t)

;; ===========================================================================
;; Python
;; ===========================================================================
(use-package python-mode
  :ensure t
  :hook
  (python-mode . eglot-ensure)
  (python-ts-mode . eglot-ensure))

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
  (go-ts-mode . eglot-ensure))

(use-package gotest
  :ensure t
  :after go-mode)

;; ===========================================================================
;; Rust
;; ===========================================================================
(use-package rust-mode
  :ensure t
  :custom
  (rust-format-on-save nil)
  :hook
  (rust-mode . eglot-ensure)
  (rust-ts-mode . eglot-ensure))

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
