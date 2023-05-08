;;; init-org.el --- Org-mode config -*- lexical-binding: t -*-
;;; Commentary:

;; Among settings for many aspects of `org-mode', this code includes
;; an opinionated setup.

;;; Code:
(use-package org
  :ensure t
  :hook
  (org-mode . visual-line-mode)
  (org-mode . org-indent-mode)
  :config
  (add-to-list 'org-modules 'org-tempo)
  (setq org-log-done t)
  (setq org-edit-timestamp-down-means-later t)
  (setq org-src-fontify-natively t)
  (setq org-export-coding-system 'utf-8)
  (setq org-fast-tag-selection-single-key 'expert)
  (setq org-html-validation-link nil)
  (setq org-export-kill-product-buffer-when-displayed t)
  (setq org-tags-column 80)
    (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (sql . t)
     (shell . t)
     ;; (fortran . t)
     ;; (julia . t)
     ;; (jupyter . t)
     ;; (scheme . t)
     ;; (haskell . t)
     (lisp . t)
     ;; (clojure . t)
     ;; (C . t)
     ;; (org . t)
     ;; (gnuplot . t)
     ;; (awk . t)
     ;; (latex . t)
     )))

(provide 'init-org)
;;; init-org.el ends here
