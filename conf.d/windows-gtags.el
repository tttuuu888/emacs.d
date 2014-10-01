;; GTAGS Setting

(autoload 'gtags-mode "gtags" "" t)

(defun gtags-create-or-update ()
  "create or update the gnu global tag file"
  (interactive)
  (if (not (= 0 (call-process "global" nil nil nil " -p"))) ; tagfile doesn't exist?
      (let ((olddir default-directory)
            (topdir (read-directory-name
                     "gtags: top of source tree:" default-directory)))
        (cd topdir)
        (shell-command "gtags && echo 'created tagfile'")
        (cd olddir)) ; restore
    ;;  tagfile already exists; update it
    (shell-command "global -u && echo 'updated tagfile'")))

;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (gtags-create-or-update)))

(defun gtags-update-single (filename)
  "Update Gtags database for changes in a single file"
  (interactive)
  (start-process "update-gtags" "update-gtags" "bash" "-c" (concat "cd " gtags-rootdir " ; gtags --single-update " filename )))

(defun gtags-update-current-file()
  (interactive)
  (defvar filename)
  (setq filename (replace-regexp-in-string gtags-rootdir "." (buffer-file-name (current-buffer))))
  (gtags-update-single filename)
  (message "Gtags updated for %s" filename))

(defun gtags-update-hook()
  "Update GTAGS file incrementally upon saving a file"
  (when gtags-mode
    (when gtags-root-dir
      (gtags-update-current-file))))

;(add-hook 'after-save-hook 'gtags-update-hook)

(add-hook 'gtags-mode-hook
          (lambda ()
            (local-set-key (kbd "M-.") 'gtags-find-tag)
            (local-set-key (kbd "M-,") 'gtags-find-rtag)
            (local-set-key (kbd "M-*") 'gtags-pop-stack)))

(add-hook 'gtags-select-mode-hook
          (lambda ()
            (local-set-key (kbd "M-*") 'gtags-pop-stack)
            (local-set-key (kbd "C-t") 'gtags-pop-stack)
            (local-set-key (kbd "p") 'previous-line)
            (local-set-key (kbd "n") 'next-line)
            (local-set-key (kbd "RET") 'gtags-select-tag)))

