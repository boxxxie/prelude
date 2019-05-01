;;; window-jump-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "window-jump" "window-jump.el" (0 0 0 0))
;;; Generated autoloads from window-jump.el

(autoload 'window-jump-left "window-jump" "\
Move to the window to the left of the current window.

\(fn)" t nil)

(autoload 'window-jump-right "window-jump" "\
Move to the window to the right of the current window.

\(fn)" t nil)

(autoload 'window-jump-down "window-jump" "\
Move to the window below the current window.

\(fn)" t nil)

(autoload 'window-jump-up "window-jump" "\
Move to the window above the current window.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "window-jump" '("wj-" "window-jump" "-wj-inf")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; window-jump-autoloads.el ends here
