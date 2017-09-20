;; Dired mode Setting

;; Don't open directory with new buffer
(put 'dired-find-alternate-file 'disabled nil)

(add-hook 'dired-mode-hook
          (lambda ()
            (local-set-key (kbd "M-o") 'dired-omit-mode)
            (local-set-key (kbd "RET")
                           (lambda ()
                             (interactive)
                             (if (file-directory-p (dired-get-filename nil t))
                                 (dired-find-alternate-file)
                                 (dired-find-file-other-window))))
            (local-set-key (kbd "DEL")
                           (lambda () (interactive) (find-alternate-file "..")))))

(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
    (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))

(add-hook 'dired-mode-hook
          (lambda ()
            (require 'dired-x)
            (dired-omit-mode)
            (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$")
            (setq dired-omit-extensions '("~"))))

;; win32 hiding gid, uid in dired mode
(when windowsp
  (setq ls-lisp-verbosity (delq 'uid ls-lisp-verbosity))
  (setq ls-lisp-verbosity (delq 'gid ls-lisp-verbosity)))



(provide 'sk-dired)
