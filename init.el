;;; init.el --- Prelude's configuration entry point.
;;
;; Copyright (c) 2011-2017 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: http://batsov.com/prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file simply sets up the default load path and requires
;; the various modules defined within Emacs Prelude.

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

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(package-initialize)

(require 'filladapt)

(require 'use-package)
(setq use-package-always-ensure t)

(setq-default filladapt-mode t)

;; why am i doing this?
(defvar current-user (getenv "USER"))

(message "Prelude is powering up... Be patient, Master %s!" current-user)

(when (version< emacs-version "24.4")
  (error "Prelude requires at least GNU Emacs 24.4, but you're running %s" emacs-version))

;; Always load newest byte code
(setq load-prefer-newer t)

(defvar prelude-dir (file-name-directory load-file-name)
  "The root dir of the Emacs Prelude distribution.")
(defvar prelude-core-dir (expand-file-name "core" prelude-dir)
  "The home of Prelude's core functionality.")
(defvar prelude-modules-dir (expand-file-name  "modules" prelude-dir)
  "This directory houses all of the built-in Prelude modules.")
(defvar prelude-personal-dir (expand-file-name "personal" prelude-dir)
  "This directory is for your personal configuration.

Users of Emacs Prelude are encouraged to keep their personal configuration
changes in this directory.  All Emacs Lisp files there are loaded automatically
by Prelude.")
(defvar prelude-personal-preload-dir (expand-file-name "preload" prelude-personal-dir)
  "This directory is for your personal configuration, that you want loaded before Prelude.")
(defvar prelude-vendor-dir (expand-file-name "vendor" prelude-dir)
  "This directory houses packages that are not yet available in ELPA (or MELPA).")
(defvar prelude-savefile-dir (expand-file-name "savefile" prelude-dir)
  "This folder stores all the automatically generated save/history-files.")
(defvar prelude-modules-file (expand-file-name "prelude-modules.el" prelude-dir)
  "This files contains a list of modules that will be loaded by Prelude.")

(unless (file-exists-p prelude-savefile-dir)
  (make-directory prelude-savefile-dir))

(defun prelude-add-subfolders-to-load-path (parent-dir)
 "Add all level PARENT-DIR subdirs to the `load-path'."
 (dolist (f (directory-files parent-dir))
   (let ((name (expand-file-name f parent-dir)))
     (when (and (file-directory-p name)
                (not (string-prefix-p "." f)))
       (add-to-list 'load-path name)
       (prelude-add-subfolders-to-load-path name)))))

;; add Prelude's directories to Emacs's `load-path'
(add-to-list 'load-path prelude-core-dir)
(add-to-list 'load-path prelude-modules-dir)
(add-to-list 'load-path prelude-vendor-dir)
(prelude-add-subfolders-to-load-path prelude-vendor-dir)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; preload the personal settings from `prelude-personal-preload-dir'
(when (file-exists-p prelude-personal-preload-dir)
  (message "Loading personal configuration files in %s..." prelude-personal-preload-dir)
  (mapc 'load (directory-files prelude-personal-preload-dir 't "^[^#\.].*el$")))

(message "Loading Prelude's core...")

;; the core stuff
(require 'prelude-packages)
(require 'prelude-custom)  ;; Needs to be loaded before core, editor and ui
(require 'prelude-ui)
(require 'prelude-core)
(require 'prelude-mode)
(require 'prelude-editor)
(require 'prelude-global-keybindings)

(message "Loading Prelude's modules...")

;; the modules
(if (file-exists-p prelude-modules-file)
    (load prelude-modules-file)
  (message "Missing modules file %s" prelude-modules-file)
  (message "You can get started by copying the bundled example file from sample/prelude-modules.el"))

;; config changes made through the customize UI will be store here
(setq custom-file (expand-file-name "custom.el" prelude-personal-dir))

;; load the personal settings (this includes `custom-file')
(when (file-exists-p prelude-personal-dir)
  (message "Loading personal configuration files in %s..." prelude-personal-dir)
  (mapc 'load (directory-files prelude-personal-dir 't "^[^#\.].*el$")))

(message "Prelude is ready to do thy bidding, Master %s!" current-user)

(prelude-eval-after-init
 ;; greet the use with some useful tip
 (run-at-time 5 nil 'prelude-tip-of-the-day))


;; lines lines-tail newline trailing space-before-tab space-after-tab
;; empty indentation-space indentation indentation-tab tabs spaces

(setq set-fill-column 120)

;; Zoom window
(require 'zoom-window)
(global-set-key (kbd "C-x C-z") 'zoom-window-zoom)



;;; init.el ends here

;; fuck whitespace shit
;; looks ugly
(setq prelude-whitespace nil)
(setq global-whitespace-cleanup-mode nil)

;; un-repl clojure repl
(let ((spiral-dir "/path/to/your/copy/of/spiral/"))
  (add-to-list 'load-path spiral-dir)
  (add-to-list 'load-path (expand-file-name "parseclj" spiral-dir))
  (require 'spiral))

;; (auto-save-mode t)
;; (auto-save-visited-mode t)
(setq auto-save-mode t)
(setq auto-save-visited-mode t)

;; not 100% sure i like this
;; currently M-S-<tab> binding is not working
(use-package buffer-flip
             :ensure t
             :bind  (
                     ("M-<tab>"   . buffer-flip-foward)
                     ("M-S-<tab>" . buffer-flip-backward)
                     :map buffer-flip-map
                     ("M-<tab>"   . buffer-flip-forward)
                     ("M-S-<tab>" . buffer-flip-backward)
                     ("M-ESC"     . buffer-flip-abort))
             :config
             (setq buffer-flip-skip-patterns
                   '("^\\*helm\\b"
                     "^\\*swiper\\*$")))

(use-package window-jump
  ;;wj-jump-frames, when set to t, will jump to windows in other frames as well as the current frame. It defaults to nil.

  :init
  (add-hook 'org-shiftup-final-hook 'window-jump-up)
  (add-hook 'org-shiftleft-final-hook 'window-jump-left)
  (add-hook 'org-shiftdown-final-hook 'window-jump-down)
  (add-hook 'org-shiftright-final-hook 'window-jump-right)

  ;; functions to bind
  :bind (
         ("S-<left>"  . window-jump-left)
         ("S-<right>" . window-jump-right)
         ("S-<up>"    . window-jump-up)
         ("S-<down>"  . window-jump-down)

         ;; intention was to have these work in org-mode, however
         ;; org-mode does S behaviour on C-S presses :(
         ;; ("C-S-<left>"  . window-jump-left)
         ;; ("C-S-<right>" . window-jump-right)
         ;; ("C-S-<up>"    . window-jump-up)
         ;; ("C-S-<down>"  . window-jump-down)
         )
  )

;;https://vxlabs.com/2014/12/04/inline-graphviz-dot-evaluation-for-graphs-using-emacs-org-mode-and-org-babel/
(org-babel-do-load-languages 'org-babel-load-languages '((dot . t)))

;; doesn't seem to work
;; (use-package minimal-session-saver
;;   :init (minimal-session-saver-install-aliases)
;;   )


;;(setq-default org-indent-mode t)
(add-hook 'org-mode-hook 'org-indent-mode)
(display-time-mode)

(global-set-key (kbd "C-z") nil) ;; maybe this could be undo
