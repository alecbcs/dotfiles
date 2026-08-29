;;;; early-init.el -- early startup optimizations -*- lexical-binding: t -*-
;;;; Commentary:
;;
;; Configuration that must run before package and GUI initialization.
;;
;;;; Code:

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
;; Native Compilation (Emacs 28+)
;; ===========================================================================
;; Configure native compilation if available
(when (native-comp-available-p)
  (setopt native-comp-jit-compilation t
          native-comp-async-report-warnings-errors 'silent
          native-comp-async-on-battery-power nil))

;;; early-init.el ends here
