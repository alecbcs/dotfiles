;;;; early-init.el -- early startup optimizations
;;;; Commentary:
;;
;; Early initialization file for performance optimization.
;; This file is loaded before init.el and before the package system
;; and GUI are initialized.
;;
;;;; Code:

;; ===========================================================================
;; Garbage Collection Optimization
;; ===========================================================================
;; Defer garbage collection during startup for faster load times
(setq gc-cons-threshold most-positive-fixnum)

;; Restore garbage collection settings after startup
(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216))) ; 16MB

;; ===========================================================================
;; Package System
;; ===========================================================================
;; Configure package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Configure use-package behavior
(setq use-package-always-ensure t)
(setq use-package-always-defer t)
(setq use-package-compute-statistics nil)
(setq use-package-verbose nil)

;; ===========================================================================
;; UI Optimization
;; ===========================================================================
;; Disable unnecessary UI elements early to prevent flashing during startup
(setq inhibit-startup-screen t)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; ===========================================================================
;; File Handler Optimization
;; ===========================================================================
;; Reduce file-name-handler-alist during startup for faster file operations
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore file handlers after startup
(add-hook 'emacs-startup-hook
  (lambda ()
    (setq file-name-handler-alist file-name-handler-alist-original)))

;; ===========================================================================
;; Native Compilation (Emacs 28+)
;; ===========================================================================
;; Configure native compilation if available
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors nil)
  (setq native-comp-deferred-compilation t))

;;; early-init.el ends here
