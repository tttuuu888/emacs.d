;; Magit Setting(windows)

(define-key global-map [(f12)] 'magit-status)

(when (not window-system)
  (custom-set-faces
   '(magit-diff-add ((t (:foreground "magenta"))))))

(setq magit-last-seen-setup-instructions "1.4.0")
