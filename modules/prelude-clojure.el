;;; prelude-clojure.el --- Emacs Prelude: Clojure programming configuration.
;;
;; Copyright © 2011-2017 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: http://batsov.com/prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Some basic configuration for clojure-mode.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'prelude-lisp)
(prelude-require-packages '(clojure-mode cider))

(eval-after-load 'clojure-mode
  '(progn
     (defun prelude-clojure-mode-defaults ()
       (subword-mode +1)
       (run-hooks 'prelude-lisp-coding-hook)
       (setq fill-column 120)
       ;;(auto-fill-mode)
       
       ;;TODO: there were a few problems with sayid.
       ;; using cider trace mode was good enough
       ;; need to come back to this in the future and see if i can fix it
       ;;(sayid-setup-package)
       )

     (setq prelude-clojure-mode-hook 'prelude-clojure-mode-defaults)

     (add-hook 'clojure-mode-hook (lambda ()
                                    (run-hooks 'prelude-clojure-mode-hook)))))

(eval-after-load 'cider
  '(progn
     (setq nrepl-log-messages t)

     ;;disable nrepl popup window on cider-jack-in
     (setq cider-repl-pop-to-buffer-on-connect nil)

     (setq cider-pprint-fn "fipp.clojure/pprint")

     (setq cider-repl-use-pretty-printing t)

     (setq cider-save-file-on-load t) ;;remove save prompt

     (setq cider-mode-hook #'eldoc-mode)
     ;;(add-hook 'cider-mode-hook #'eldoc-mode)

     ;; allows multi-line mini-buffer eldoc
     (setq eldoc-echo-area-use-multiline-p 'truncate-sym-name-if-fit)

     (setq cider-overlays-use-font-lock t)

     (setq cider-prompt-for-symbol nil)

     (setq nrepl-hide-special-buffers t)

     (defun prelude-cider-repl-mode-defaults ()
       (subword-mode +1)
       (run-hooks 'prelude-interactive-lisp-coding-hook))

     (setq prelude-cider-repl-mode-hook 'prelude-cider-repl-mode-defaults)

     (add-hook 'cider-repl-mode-hook (lambda ()
                                       (run-hooks 'prelude-cider-repl-mode-hook)))))

(provide 'prelude-clojure)

;;; prelude-clojure.el ends here
