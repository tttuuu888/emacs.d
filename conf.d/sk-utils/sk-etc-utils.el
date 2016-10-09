;; The other functions Setting

(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a")))

(defun insert-date-and-time ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a %p %l:%M")))

(defun nuke-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapc (lambda (x) (kill-buffer x))
          (buffer-list))
  (delete-other-windows))

;; Hide ^M
(defun hide-ctrl-M ()
  "Hides the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))


;; Clear Eshell buffer
(defun eshell/clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))



(provide 'sk-etc-utils)
