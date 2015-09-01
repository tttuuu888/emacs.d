;; The other functions Setting

;;;; Turn-off scratch buffer save
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (get-buffer "*scratch*")
              (with-current-buffer "*scratch*"
                (auto-save-mode -1)
                (setq buffer-offer-save nil)))))


;; insert date into buffer at point
;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a %p %l:%M")))


;; ;; Kills all them buffers except scratch
;; ;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
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
