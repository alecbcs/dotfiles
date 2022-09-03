;;; podman-tramp.el --- TRAMP integration for podman containers  -*- lexical-binding: t; -*-

;; Copyright (C) 2015 Mario Rodas <marsam@users.noreply.github.com>

;; Author: Mario Rodas <marsam@users.noreply.github.com>
;; URL: https://github.com/emacs-pe/podman-tramp.el
;; Keywords: podman, convenience
;; Version: 0.1.1
;; Package-Requires: ((emacs "24") (cl-lib "0.5"))

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; `podman-tramp.el' offers a TRAMP method for Podman containers.
;;
;; > **NOTE**: `podman-tramp.el' relies in the `podman exec` command.  Tested
;; > with podman version 1.6.x but should work with versions >1.3.  Podman
;; > also works.
;;
;; ## Usage
;;
;; Offers the TRAMP method `podman` to access running containers
;;
;;     C-x C-f /podman:user@container:/path/to/file
;;
;;     where
;;       user           is the user that you want to use inside the container (optional)
;;       container      is the id or name of the container
;;
;; ### [Multi-hop][] examples
;;
;; If you container is hosted on `vm.example.net`:
;;
;;     /ssh:vm-user@vm.example.net|podman:user@container:/path/to/file
;;
;; If you need to run the `podman` command as, say, the `root` user:
;;
;;     /sudo:root@localhost|podman:user@container:/path/to/file
;;
;; ## Troubleshooting
;;
;; ### Tramp hangs on Alpine container
;;
;; Busyboxes built with the `ENABLE_FEATURE_EDITING_ASK_TERMINAL' config option
;; send also escape sequences, which `tramp-wait-for-output' doesn't ignores
;; correctly.  Tramp upstream fixed in [98a5112][] and is available since
;; Tramp>=2.3.
;;
;; For older versions of Tramp you can dump [podman-tramp-compat.el][] in your
;; `load-path' somewhere and add the following to your `init.el', which
;; overwrites `tramp-wait-for-output' with the patch applied:
;;
;;     (require 'podman-tramp-compat)
;;
;; ### Tramp does not respect remote `PATH'
;;
;; This is a known issue with Tramp, but is not a bug so much as a poor default
;; setting.  Adding `tramp-own-remote-path' to `tramp-remote-path' will make
;; Tramp use the remote's `PATH' environment varialbe.
;;
;;     (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;;
;; [Multi-hop]: https://www.gnu.org/software/emacs/manual/html_node/tramp/Ad_002dhoc-multi_002dhops.html
;; [98a5112]: http://git.savannah.gnu.org/cgit/tramp.git/commit/?id=98a511248a9405848ed44de48a565b0b725af82c
;; [podman-tramp-compat.el]: https://github.com/emacs-pe/podman-tramp.el/raw/master/podman-tramp-compat.el

;;; Code:
(eval-when-compile (require 'cl-lib))

(require 'tramp)
(require 'tramp-cache)

(defgroup podman-tramp nil
  "TRAMP integration for Podman containers."
  :prefix "podman-tramp-"
  :group 'applications
  :link '(url-link :tag "Github" "https://github.com/emacs-pe/podman-tramp.el")
  :link '(emacs-commentary-link :tag "Commentary" "podman-tramp"))

(defcustom podman-tramp-podman-executable "podman"
  "Path to podman (or compatible) executable."
  :type '(choice
          (const "podman")
          (string))
  :group 'podman-tramp)

;;;###autoload
(defcustom podman-tramp-podman-options nil
  "List of podman options."
  :type '(repeat string)
  :group 'podman-tramp)

(defcustom podman-tramp-use-names nil
  "Whether use names instead of id."
  :type 'boolean
  :group 'podman-tramp)

;;;###autoload
(defconst podman-tramp-completion-function-alist
  '((podman-tramp--parse-running-containers  ""))
  "Default list of (FUNCTION FILE) pairs to be examined for podman method.")

;;;###autoload
(defconst podman-tramp-method "podman"
  "Method to connect podman containers.")

(defun podman-tramp--running-containers ()
  "Collect podman running containers.
Return a list of containers of the form: \(ID NAME\)"
  (cl-loop for line in (cdr (ignore-errors (apply #'process-lines podman-tramp-podman-executable (append podman-tramp-podman-options (list "ps")))))
           for info = (split-string line "[[:space:]]+" t)
           collect (cons (car info) (last info))))

(defun podman-tramp--parse-running-containers (&optional ignored)
  "Return a list of (user host) tuples.
TRAMP calls this function with a filename which is IGNORED.  The
user is an empty string because the podman TRAMP method uses bash
to connect to the default user containers."
  (cl-loop for (id name) in (podman-tramp--running-containers)
           collect (list "" (if podman-tramp-use-names name id))))

;;;###autoload
(defun podman-tramp-cleanup ()
  "Cleanup TRAMP cache for podman method."
  (interactive)
  (let ((containers (apply 'append (podman-tramp--running-containers))))
    (maphash (lambda (key _)
               (and (vectorp key)
                    (string-equal podman-tramp-method (tramp-file-name-method key))
                    (not (member (tramp-file-name-host key) containers))
                    (remhash key tramp-cache-data)))
             tramp-cache-data))
  (setq tramp-cache-data-changed t)
  (if (zerop (hash-table-count tramp-cache-data))
      (ignore-errors (delete-file tramp-persistency-file-name))
    (tramp-dump-connection-properties)))

;;;###autoload
(defun podman-tramp-add-method ()
  "Add podman tramp method."
  (add-to-list 'tramp-methods
               `(,podman-tramp-method
                 (tramp-login-program      ,podman-tramp-podman-executable)
                 (tramp-login-args         (,podman-tramp-podman-options ("exec" "-it") ("-u" "%u") ("%h") ("sh")))
                 (tramp-remote-shell       "/bin/sh")
                 (tramp-remote-shell-args  ("-i" "-c")))))

;;;###autoload
(eval-after-load 'tramp
  '(progn
     (podman-tramp-add-method)
     (tramp-set-completion-function podman-tramp-method podman-tramp-completion-function-alist)))

(provide 'init-podman)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; podman-tramp.el ends here
