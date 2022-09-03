;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of Emacs programming language modes.

;;;; Code:
(use-package go-mode
  :custom
  (gofmt-command "goimports")
  :hook ((go-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports)))

(use-package yaml-mode)

(use-package dockerfile-mode)

(use-package lsp-pyright
  :hook (python-mode . (lambda () (require 'lsp-pyright)))
  :init (when (executable-find "python3")
          (setq lsp-pyright-python-executable-cmd "python3")))

(provide 'init-prog-langs)

;;; init-prog-langs.el ends here
