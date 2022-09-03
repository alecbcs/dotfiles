;;; init-lsp.el --- config for lsp-mode
;;; Commentary:

;; Among settings for many aspects of `lsp-mode', this code includes
;; an opinionated setup.

;;; Code:
(use-package lsp-mode
  :hook ((c-mode      ; clangd
      c++-mode        ; clangd
      c-or-c++-mode   ; clangd
      java-mode       ; eclipse-jdtls
      js-mode         ; ts-ls (tsserver wrapper)
      js-jsx-mode     ; ts-ls (tsserver wrapper)
      typescript-mode ; ts-ls (tsserver wrapper)
      go-mode         ; gopls
      python-mode     ; pyright
      web-mode        ; ts-ls/HTML/CSS
      haskell-mode    ; haskell-language-server
      ) . lsp-deferred)
  :commands lsp
  :config
  (setq lsp-auto-guess-root t)
  (setq lsp-log-io nil)
  (setq lsp-restart 'auto-restart)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-eldoc-hook nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-semantic-tokens-enable nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-imenu nil)
  (setq lsp-enable-snippet nil)
  (setq read-process-output-max (* 1024 1024)) ;; 1MB
  (setq lsp-idle-delay 0.5))

(provide 'init-lsp)
;;; init-lsp.el ends here
