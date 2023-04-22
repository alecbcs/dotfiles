;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of markdown-mode.

;;;; Code:
(use-package markdown-mode
  :ensure t
  :hook (markdown-mode . visual-line-mode)
  :init
  (setq markdown-enable-wiki-links t)
  (setq markdown-link-space-sub-char "-")
  (setq markdown-command "multimarkdown")
  (setq markdown-header-scaling t)
  (setq markdown-header-scaling-values '(2.0 1.7 1.4 1.1 1.0 1.0)))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
     ("\\.css\\'"   . web-mode)
     ("\\.jsx?\\'"  . web-mode)
     ("\\.tsx?\\'"  . web-mode)
     ("\\.json\\'"  . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2) ; HTML
  (setq web-mode-css-indent-offset 2)    ; CSS
  (setq web-mode-code-indent-offset 2)   ; JS/JSX/TS/TSX
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))))

(provide 'init-markdown)
;;; init-markdown.el ends here
