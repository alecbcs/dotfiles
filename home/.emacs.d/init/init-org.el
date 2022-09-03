;;; init-org.el --- Org-mode config -*- lexical-binding: t -*-
;;; Commentary:

;; Among settings for many aspects of `org-mode', this code includes
;; an opinionated setup.

;;; Code:

;; Various preferences
(setq org-log-done t
      org-edit-timestamp-down-means-later t
      org-src-fontify-natively t
      org-export-coding-system 'utf-8
      org-fast-tag-selection-single-key 'expert
      org-html-validation-link nil
      org-export-kill-product-buffer-when-displayed t
      org-tags-column 80)


;; Lots of stuff from http://doc.norang.ca/org-mode.html

;; Re-align tags when window shape changes
(with-eval-after-load 'org-agenda
  (add-hook 'org-agenda-mode-hook
            (lambda () (add-hook 'window-configuration-change-hook 'org-agenda-align-tags nil t))))


;; Use visual-line-mode in Org-Mode
(defun my-org-mode-hook ()
  (visual-line-mode t)
  (org-indent-mode t))
(add-hook 'org-mode-hook 'my-org-mode-hook)

(provide 'init-org)
;;; init-org.el ends here
