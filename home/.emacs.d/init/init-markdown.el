;;;; init-markdown.el -- markdown and web-mode config -*- lexical-binding: t -*-
;;;; Commentary:

;; Configuration for Emacs's built-in tree-sitter Markdown mode.

;;;; Code:
(use-package markdown-ts-mode
  :ensure nil
  :mode (("\\.md\\'" . markdown-ts-mode)
         ("\\.markdown\\'" . markdown-ts-mode))
  :hook (markdown-ts-mode . visual-line-mode))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'"   . web-mode)
         ("\\.jsx?\\'"  . web-mode)
         ("\\.tsx?\\'"  . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2) ; HTML
  (setq web-mode-css-indent-offset 2)    ; CSS
  (setq web-mode-code-indent-offset 2)   ; JS/JSX/TS/TSX
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))))

(provide 'init-markdown)
;;; init-markdown.el ends here
