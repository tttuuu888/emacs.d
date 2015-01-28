;; Dired mode Setting

;; Don't open directory with new buffer
(put 'dired-find-alternate-file 'disabled nil)

(add-hook 'dired-mode-hook
          (lambda ()
            (local-set-key (kbd "M-o") 'dired-omit-mode)
            (local-set-key (kbd "RET") 'dired-find-file-other-window)
            (local-set-key (kbd "^")
                           (lambda () (interactive) (find-alternate-file "..")))
            (local-set-key (kbd "DEL")
                           (lambda () (interactive) (find-alternate-file "..")))
                                        ; was dired-up-directory
            ))


;; Dired Enhancements ------------------------------------------------------------
 (eval-after-load "dired"
      '(progn
         (defadvice dired-advertised-find-file (around dired-subst-directory activate)
           "Replace current buffer if file is a directory."
           (interactive)
            (let* ((orig (current-buffer))
                   ;; (filename (dired-get-filename))
                   (filename (dired-get-filename t t))
                  (bye-p (file-directory-p filename)))
             ad-do-it
             (when (and bye-p (not (string-match "[/\\\\]\\.$" filename)))
               (kill-buffer orig))))))

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
          (function (lambda ()
		      (load "dired-x")
                      ;; Set dired-x buffer-local variables here.  For example:
                      (setq dired-omit-files-p t)
		      (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$")
		      (setq dired-omit-extensions '("~"))
                      )))


;;;; win32 hiding gid, uid in dired mode
(when win32p
  (setq ls-lisp-verbosity (delq 'uid ls-lisp-verbosity))
  (setq ls-lisp-verbosity (delq 'gid ls-lisp-verbosity)))
