;;;; init.el -- personal main emacs config
;;;; Commentary:

;; This code includes an opinionated setup for my customized version
;; of Emacs programming language modes.

;;;; Code:
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package eglot
  :ensure t
  :config
  (setq eglot-report-progress nil))

(use-package python-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'eglot-ensure))

(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'eglot-ensure)
  (add-hook 'before-save-hook 'eglot-format-buffer))

(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package json-mode
  :ensure t)

(provide 'init-prog-langs)

;;; init-prog-langs.el ends here
