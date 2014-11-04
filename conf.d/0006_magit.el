;; Magit Setting(windows)

(define-key global-map [(f12)] 'magit-status)

(when win32p
  (progn
    (add-to-list 'load-path "~/.emacs.d/util/win_magit-1.2.0")
    (require 'magit)))

(when (not window-system)
  (custom-set-faces
   '(magit-diff-add ((t (:foreground "magenta"))))))
