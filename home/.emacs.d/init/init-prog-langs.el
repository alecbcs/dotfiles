;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of Emacs programming language modes.

;;;; Code:
(use-package eglot
  :ensure t)

(use-package python-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'eglot-ensure))

(use-package go-mode
  :ensure t
  :custom
  (gofmt-command "goimports")
  :hook ((go-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports)))

(provide 'init-prog-langs)

;;; init-prog-langs.el ends here
