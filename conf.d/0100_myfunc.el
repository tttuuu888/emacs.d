;; My functions

(defun parent-directory (dir)
  (unless (equal "/" dir)
    (file-name-directory (directory-file-name dir))))

(defun find-file-in-tree (dir fname)
  (let ((file (concat dir fname))
        (parent (parent-directory dir)))
    (if (file-exists-p file)
        dir
        (when parent
          (find-file-in-tree parent fname)))))

(defun sk-make ()
  "Find a Makefile path and excute make"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (compile (concat "make -C " dir)))))


(defun sk-clean ()
  "Find a Makefile path and excute make"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (start-process
       "sk-clean"
       nil
       "make"
       "-C"
       dir
       "clean"))))


(defun sk-rebuild ()
  "Find a Makefile path and excute clean"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (set-process-sentinel 
       (start-process
        "sk-clean"
        nil                             ;output buffer name
        "make"
        "-C"
        dir
        "clean")
       (lambda (p e) (when (= 0 (process-exit-status p))
                       (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
                         (compile (concat "make -C " dir)))))))))

(add-hook 'prog-mode-hook
          (lambda () (when (derived-mode-p 'c-mode 'c++-mode)
                                           (local-set-key [(f9)] 'sk-rebuild))))
